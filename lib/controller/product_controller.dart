import 'package:home_keeps/controller/base_controller.dart';
import 'package:home_keeps/data/response/api_response.dart';
import 'package:home_keeps/models/product_model.dart';
import 'package:home_keeps/repository/product_repo.dart';

class ProductController extends BaseController {
  final ProductRepo productRepo = ProductRepo();
  ProductModel? productModel;

  Future<void> getProduct() async {
    try {
      setLoading();

      final result = await productRepo.getProduct();

      productModel = result;

      setApiResponse(ApiResponse.completed(result));

      handleSuccess('', showSuccessSnackBar: false);

      update();
    } catch (e) {
      setApiResponse(ApiResponse.error(e.toString()));

      handleError(e.toString());
    }
  }
}
