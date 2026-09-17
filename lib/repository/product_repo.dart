import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/data/network/network_api_service.dart';
import 'package:home_keeps/models/product_model.dart';

class AuthRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future<ProductModel> getProduct() async {
    final response = await _apiService.get(AppUrl.customerMe);

    return response;
  }
}
