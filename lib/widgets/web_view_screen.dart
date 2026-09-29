import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String gameUrl;
  final String gameTitle;
  final bool forcePortrait;
  final VoidCallback? onExit;
  final bool enableWebViewHistory;
  final String? jsChannelName;
  final void Function(String message)? onJsMessage;
  final String? htmlContent;

  const InAppWebViewScreen({
    super.key,
    required this.gameUrl,
    required this.gameTitle,
    this.forcePortrait = false,
    this.onExit,
    this.enableWebViewHistory = true,
    this.jsChannelName, // ✅ new
    this.onJsMessage, // ✅ new
    this.htmlContent,
  });

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen>
    with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;
  bool _isFullscreen = false;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setOrientation();
    _initializeWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopAllMedia();
    _resetOrientation();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopAllMedia();
    } else if (state == AppLifecycleState.resumed) {
      // Only pause when resumed to a different screen
      if (!mounted) {
        _stopAllMedia();
      }
    }
  }

  @override
  void deactivate() {
    // Called when widget is removed from the tree (navigating away)
    _stopAllMedia();
    super.deactivate();
  }

  void _setOrientation() {
    if (widget.forcePortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  // Pause all media when navigating away
  // void _pauseAllMedia() {
  //   final pauseScript = '''
  //     (function() {
  //       // Pause all videos
  //       document.querySelectorAll('video').forEach(function(video) {
  //         video.pause();
  //       });

  //       // Pause all audio
  //       document.querySelectorAll('audio').forEach(function(audio) {
  //         audio.pause();
  //       });

  //       // Stop Web Audio API contexts
  //       if (window.AudioContext || window.webkitAudioContext) {
  //         if (window.audioContext && window.audioContext.state === 'running') {
  //           window.audioContext.suspend();
  //         }
  //       }
  //     })();
  //   ''';

  //   _controller.runJavaScript(pauseScript);
  // }

  // Stop all media completely when disposing
  void _stopAllMedia() {
    final stopScript = '''
      (function() {
        // Stop and remove all videos
        document.querySelectorAll('video').forEach(function(video) {
          video.pause();
          video.src = '';
          video.load();
        });
        
        // Stop and remove all audio
        document.querySelectorAll('audio').forEach(function(audio) {
          audio.pause();
          audio.src = '';
          audio.load();
        });
        
        // Close Web Audio API contexts
        if (window.AudioContext || window.webkitAudioContext) {
          if (window.audioContext && window.audioContext.state === 'running') {
            window.audioContext.close();
          }
        }
        
        // Clear all intervals and timeouts
        var highestTimeoutId = setTimeout(";");
        for (var i = 0; i < highestTimeoutId; i++) {
          clearTimeout(i);
        }
        
        var highestIntervalId = setInterval(";");
        for (var i = 0; i < highestIntervalId; i++) {
          clearInterval(i);
        }
      })();
    ''';

    _controller.runJavaScript(stopScript);
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onProgress: (int progress) =>
              setState(() => _loadingProgress = progress),
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _injectResponsiveCSS(controller);
            _injectMediaControlScript(controller);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${error.description}'),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () => controller.reload(),
                  ),
                ),
              );
            }
          },
          onNavigationRequest: (_) => NavigationDecision.navigate,
        ),
      );

    // ✅ JS Channel add karo agar provide kiya ho
    if (widget.jsChannelName != null && widget.onJsMessage != null) {
      controller.addJavaScriptChannel(
        'FlutterBridge', // ← CHANGE THIS
        onMessageReceived: (JavaScriptMessage msg) {
          if (kDebugMode)
            print('📨 JS Channel [TellerConnect]: ${msg.message}');
          widget.onJsMessage?.call(msg.message);
        },
      );
    }

    // ✅ HTML string ya URL — dono handle karo
    if (widget.htmlContent != null && widget.htmlContent!.isNotEmpty) {
      controller.loadHtmlString(
        widget.htmlContent!,
        baseUrl: 'https://teller.io', // ✅ ADD THIS — fixes origin=null
      );
    } else {
      controller.loadRequest(Uri.parse(widget.gameUrl));
    }

    _controller = controller;
  }

  void _injectMediaControlScript(WebViewController controller) {
    final script = '''
      (function() {
        // Store audio context globally for later control
        var OriginalAudioContext = window.AudioContext || window.webkitAudioContext;
        if (OriginalAudioContext) {
          window.audioContext = new OriginalAudioContext();
        }
        
        // Listen for visibility changes
        document.addEventListener('visibilitychange', function() {
          if (document.hidden) {
            // Pause all media when tab/app is hidden
            document.querySelectorAll('video, audio').forEach(function(media) {
              media.pause();
            });
          }
        });
      })();
    ''';

    controller.runJavaScript(script);
  }

  void _injectResponsiveCSS(WebViewController controller) {
    final script = '''
      (function() {
        if (!document.querySelector('meta[name="viewport"]')) {
          var meta = document.createElement('meta');
          meta.name = 'viewport';
          meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
          document.head.appendChild(meta);
        }
        
        var style = document.createElement('style');
        style.innerHTML = `
          html, body {
            overflow-x: hidden !important;
            width: 100% !important;
            max-width: 100vw !important;
            touch-action: manipulation !important;
          }
          
          body {
            margin: 0 !important;
            padding: 0 !important;
          }
          
          * {
            max-width: 100% !important;
            box-sizing: border-box !important;
          }
          
         img, canvas, video {
  max-width: 100% !important;
  height: auto !important;
}

iframe {
  max-width: 100% !important;
  width: 100% !important;
  height: 100% !important;   /* ← let iframe fill its container */
  border: none !important;
}
          
          * {
            -webkit-overflow-scrolling: touch !important;
          }
          
          body {
            -webkit-text-size-adjust: 100% !important;
            -moz-text-size-adjust: 100% !important;
            -ms-text-size-adjust: 100% !important;
          }
        `;
        document.head.appendChild(style);
        
        var lastTouchEnd = 0;
        document.addEventListener('touchend', function(event) {
          var now = Date.now();
          if (now - lastTouchEnd <= 300) {
            event.preventDefault();
          }
          lastTouchEnd = now;
        }, false);
      })();
    ''';

    controller.runJavaScript(script);
  }

  // Update the back button state
  Future<void> _updateBackButtonState() async {
    if (widget.enableWebViewHistory) {
      final canGoBack = await _controller.canGoBack();
      if (mounted) {
        setState(() {
          _canGoBack = canGoBack;
        });
      }
    }
  }

  // Override back button to stop media before popping
  Future<bool> _onWillPop() async {
    // If history navigation is enabled and webview can go back
    if (widget.enableWebViewHistory && _canGoBack) {
      await _controller.goBack();
      await _updateBackButtonState();
      return false; // Don't pop the screen
    }
    _stopAllMedia();
    // Wait a bit for the script to execute
    await Future.delayed(const Duration(milliseconds: 100));
    if (widget.onExit != null) {
      widget.onExit!();
      return false;
    }
    return true;
  }

  // Handle app bar back button
  Future<void> _handleAppBarBack() async {
    // If history navigation is enabled and webview can go back
    if (widget.enableWebViewHistory && _canGoBack) {
      await _controller.goBack();
      await _updateBackButtonState();
    } else {
      // Close the screen
      _stopAllMedia();
      await Future.delayed(const Duration(milliseconds: 100));
      if (widget.onExit != null) {
        widget.onExit!();
      } else {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _isFullscreen
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: _handleAppBarBack,
                  icon: Icon(Icons.keyboard_backspace),
                ),

                // onTap: () async {
                //   _stopAllMedia();
                //   await Future.delayed(const Duration(milliseconds: 100));
                //   if (widget.onExit != null) {
                //     widget.onExit!();
                //   } else {
                //     Get.back();
                //   }
                // },
                centerTitle: true,

                title: Text(widget.gameTitle),
              ),
        body: SafeArea(
          top: !_isFullscreen,
          bottom: !_isFullscreen,
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(value: _loadingProgress / 100),
                      const SizedBox(height: 16),
                      Text('Loading... $_loadingProgress%'),
                    ],
                  ),
                ),
              if (_isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _loadingProgress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
