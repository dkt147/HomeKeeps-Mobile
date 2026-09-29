import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/data/network/network_api_service.dart';

class CheckoutRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future checkoutOffer({
    required String planId,
    required String productId,
  }) async {
    final idempotencyKey =
        'homekeep-checkout-${DateTime.now().toIso8601String()}';

    final response = await _apiService.postWithHeaders(
      '${AppUrl.offersCheckout}/$planId/checkout',
      {"product_id": productId, "terms_accepted": true},
      extraHeaders: {'Idempotency-Key': idempotencyKey},
    );

    return response;
  }
}
