import 'package:get/get.dart';
import 'package:home_keeps/data/response/api_response.dart';
import 'package:home_keeps/data/response/status.dart';
import 'package:home_keeps/utils/utils.dart';

abstract class BaseController extends GetxController {
  // API response state
  ApiResponse apiResponse = ApiResponse.init();
  RxBool isSecondLoading = false.obs;
  bool isDisposed = true;
  RxInt forceUpdateForOBX = 0.obs;
  bool get isLoading => apiResponse.status == Status.loading;
  @override
  void update([
    List<Object>? ids,
    bool condition = true,
    bool forceOBX = false,
  ]) {
    0.delay(() {
      Utils.logInfo("update $runtimeType", name: "XGETX~");
      super.update(ids, condition);
      if (forceOBX) forceUpdateForOBX.value++;
    });
  }

  /// Set the API response state and notify listeners.
  void setApiResponse(ApiResponse response, {bool forceUpdateForOBX = true}) {
    // Defer state update after the build phase
    Future.delayed(Duration.zero, () {
      Utils.logInfo("Setting ApiResponse to: $response", name: "XGETX~");
      apiResponse = response;
      update(null, true, forceUpdateForOBX);
    });
  }

  /// Set the API response state to loading.
  void setLoading() {
    Utils.logC("Setting ApiResponse to loading");
    setApiResponse(ApiResponse.loading());
  }

  void setSecondLoading(bool b) {
    // Defer state update after the build phase
    Future.delayed(Duration.zero, () {
      Utils.logC("Setting second loading to: $b", name: "XGETX~");
      isSecondLoading.value = b;
      update();
    });
  }

  /// Handle errors by logging them and setting the error state.
  void handleError(
    dynamic e, {
    bool showErrorSnackBar = true,
    bool isSecondLoading = false,
  }) {
    Utils.logError("Error: $e");
    if (showErrorSnackBar) {
      Utils.errorBar(_friendlyMessage(e));
    }
    Utils.logInfo("Setting ApiResponse to error: $e");
    if (isSecondLoading) {
      setSecondLoading(false);
    } else {
      setApiResponse(ApiResponse.error(e.toString()));
    }
  }

  String _friendlyMessage(dynamic e) {
    final raw = e.toString();
    final looksTechnical =
        raw.contains('Socket') ||
        raw.contains('uri=') ||
        raw.contains('http://') ||
        raw.contains('https://') ||
        raw.contains('Connection') ||
        raw.contains('Client');
    if (looksTechnical) {
      return "unable_to_connect_error".tr;
    }
    return raw
        .replaceFirst("SocketException: ", "")
        .replaceFirst("Exception: ", "");
  }

  /// Show a success message and perform additional success logic.
  void handleSuccess(
    String message, {
    bool showSuccessSnackBar = true,
    Map<String, dynamic>? data,
    bool isSecondLoading = false,
    bool noLoading = false,
  }) {
    Utils.logSuccess("Success: $message");
    // Add success handling (like showing a success snackbar) here
    if (showSuccessSnackBar) {
      Utils.successBar(message);
    }
    // Utils.logInfo("Setting ApiResponse to completed: $message");
    if (!noLoading) {
      if (isSecondLoading) {
        setSecondLoading(false);
      } else {
        setApiResponse(ApiResponse.completed(data ?? message));
      }
    }
  }

  /// Centralized response handler for API responses.
  Future<dynamic> handleApiResponse(Future<dynamic> apiCall) async {
    try {
      var response = await apiCall;
      if (response['status'] == 'success') {
        debugLog('API Response Success', {}); //response);
        return response['data'];
      } else {
        debugLogE('API Response Error', response);
        throw response['message'];
      }
    } catch (e) {
      debugLogE('API Response Exception', {'error': e.toString()});
      rethrow;
    }
  }

  /// Logs detailed debug information.
  void debugLog(String message, dynamic data) {
    Utils.logInfo('DEBUG: $message | Data: $data');
  }

  /// Logs detailed debug information.
  void debugLogE(String message, dynamic data) {
    Utils.logError('DEBUG: $message | Data: $data');
  }

  /// Optional: Override this method to perform actions when closing the controller.
  @override
  void onClose() {
    Utils.logInfo("onClose $runtimeType", name: "XGETX~");
    super.onClose();
  }

  @override
  void dispose() {
    Utils.logInfo("dispose $runtimeType", name: "XGETX~");
    isDisposed = true;
    super.dispose();
  }

  @override
  void onInit() {
    Utils.logInfo("onInit $runtimeType", name: "XGETX~");
    isDisposed = false;
    super.onInit();
  }
}

// for setting value of RX Value with delay
void setRxValue(dynamic obj, dynamic value) {
  Future.delayed(Duration.zero, () {
    obj.value = value;
  });
}

extension RxValueExtension<T> on Rx<T> {
  /// Sets the value of the Rx object with a delay.
  void setValue(T value) {
    setRxValue(this, value);
  }
}

extension RxListValueExtension<T> on RxList<T> {
  /// Sets the value of the Rx object with a delay.
  void setValue(List<T> value) {
    setRxValue(this, value);
  }
}

extension RxnValueExtension<T> on Rxn<T> {
  /// Sets the value of the Rx object with a delay.
  void setValue(T value) {
    setRxValue(this, value);
  }
}

extension RxMapValueExtension<T> on RxMap<String, T> {
  /// Sets the value of the Rx object with a delay.
  void setValue(Map<String, T> value) {
    setRxValue(this, value);
  }
}

extension RxSetValueExtension<T> on RxSet<T> {
  /// Sets the value of the Rx object with a delay.
  void setValue(Set<T> value) {
    setRxValue(this, value);
  }
}



// , RxList<T>, RxMap<String, T>, RxSet<T>, Rxn<T>