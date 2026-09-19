import 'dart:io';

import 'package:home_keeps/controller/base_controller.dart';
import 'package:home_keeps/data/response/api_response.dart';
import 'package:home_keeps/models/document_model.dart';
import 'package:home_keeps/models/home_summary_model.dart';
import 'package:home_keeps/models/manufactures_model.dart';
import 'package:home_keeps/models/product_category_model.dart';
import 'package:home_keeps/models/product_detail_model.dart';
import 'package:home_keeps/models/product_model.dart';
import 'package:home_keeps/models/service_case_detail_model.dart';
import 'package:home_keeps/models/warranty_cases_model.dart';
import 'package:home_keeps/repository/product_repo.dart';

class ProductController extends BaseController {
  final ProductRepo productRepo = ProductRepo();
  ProductModel? productModel;
  WarrantyCaseStatusModel? warrantyCaseStatusModel;
  HomeSummaryModel? homeSummaryModel;
  ProductDetailModel? productDetailModel;
  bool isDeleting = false;
  bool isReminderUpdating = false;
  List<String> faultTypes = [];
  bool isFaultTypesLoading = true;
  bool faultTypesError = false;
  bool isCaseCreating = false;
  ServiceCaseModel? serviceCase;
  bool isCaseLoading = true;
  bool isCreatingProduct = false;
  bool caseError = false;
  List<ServiceCaseModel> serviceCases = [];
  bool isServiceCasesLoading = true;
  bool serviceCasesError = false;
  List<AppDocument> documents = [];
  bool isDocumentsLoading = true;
  bool documentsError = false;
  bool isUploadingDocument = false;
  ProductCategoriesModel? categoriesModel;
  bool isCategoriesLoading = true;
  bool categoriesError = false;
  bool isUpdatingProduct = false;
  ManufacturesModel? manufacturersModel;
  bool isManufacturersLoading = true;
  bool manufacturersError = false;
  bool get warrantyReminderEnabled =>
      productDetailModel?.data?.warrantyReminder?.enabled ??
      productDetailModel?.data?.warrantyReminderEnabled ??
      false;

  void _setReminderLocal(bool value) {
    final data = productDetailModel?.data;
    if (data == null) return;
    data.warrantyReminderEnabled = value;
    data.warrantyReminder = WarrantyReminder(enabled: value);
  }

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

  Future<void> getHomeSummary() async {
    try {
      setLoading();

      final result = await productRepo.getHomeSummary();

      homeSummaryModel = result;

      setApiResponse(ApiResponse.completed(result));

      handleSuccess('', showSuccessSnackBar: false);

      update();
    } catch (e) {
      setApiResponse(ApiResponse.error(e.toString()));

      handleError(e.toString());
    }
  }

  Future<void> getWarrantyCase() async {
    try {
      setLoading();

      final result = await productRepo.getWarrantyCase();

      warrantyCaseStatusModel = result;

      setApiResponse(ApiResponse.completed(result));

      handleSuccess('', showSuccessSnackBar: false);

      update();
    } catch (e) {
      setApiResponse(ApiResponse.error(e.toString()));

      handleError(e.toString());
    }
  }

  Future<void> getProductDetail({required String id}) async {
    try {
      setLoading();

      final result = await productRepo.getProductDetail(id: id);

      productDetailModel = result;

      setApiResponse(ApiResponse.completed(result));

      handleSuccess('', showSuccessSnackBar: false);

      update();
    } catch (e) {
      setApiResponse(ApiResponse.error(e.toString()));

      handleError(e.toString());
    }
  }

  Future<bool> deleteProduct({required String id}) async {
    try {
      isDeleting = true;
      update();

      final success = await productRepo.deleteProduct(id: id);

      if (success) {
        handleSuccess('Appliance removed', showSuccessSnackBar: true);

        getProduct();
        getHomeSummary();
      } else {
        handleError('Could not remove appliance');
      }

      return success;
    } catch (e) {
      handleError(e.toString());
      return false;
    } finally {
      isDeleting = false;
      update();
    }
  }

  Future<void> updateWarrantyReminder({
    required String id,
    required bool enabled,
  }) async {
    if (isReminderUpdating) return;

    final previous = warrantyReminderEnabled;

    _setReminderLocal(enabled);
    isReminderUpdating = true;
    update();

    try {
      await productRepo.updateWarrantyReminder(id: id, enabled: enabled);
    } catch (e) {
      _setReminderLocal(previous);
      handleError(e.toString());
    } finally {
      isReminderUpdating = false;
      update();
    }
  }

  Future<void> getFaultTypes({required String categoryId}) async {
    try {
      isFaultTypesLoading = true;
      faultTypesError = false;
      faultTypes = [];
      update();

      faultTypes = await productRepo.getFaultTypes(categoryId: categoryId);
    } catch (e) {
      faultTypesError = true;
      handleError(e.toString());
    } finally {
      isFaultTypesLoading = false;
      update();
    }
  }

  Future<String?> createServiceCase({
    required String productId,
    required String faultType,
    required String description,
    required List<dynamic> preferredSlots,
  }) async {
    if (isCaseCreating) return null;

    try {
      isCaseCreating = true;
      update();

      final result = await productRepo.createServiceCase(
        productId: productId,
        faultType: faultType,
        description: description,
        preferredSlots: preferredSlots,
      );

      if (result.caseId == null) {
        handleError('Could not start the case');
        return null;
      }

      return result.caseId;
    } catch (e) {
      handleError(e.toString());
      return null;
    } finally {
      isCaseCreating = false;
      update();
    }
  }

  Future<void> getServiceCase({required String caseId}) async {
    try {
      isCaseLoading = true;
      caseError = false;
      serviceCase = null;
      update();

      serviceCase = await productRepo.getServiceCase(caseId: caseId);
    } catch (e) {
      caseError = true;
      handleError(e.toString());
    } finally {
      isCaseLoading = false;
      update();
    }
  }

  Future<void> getServiceCases({bool silent = false}) async {
    try {
      if (!silent) {
        isServiceCasesLoading = true;
        serviceCasesError = false;
        update();
      }

      serviceCases = await productRepo.getServiceCases();
      serviceCasesError = false;
    } catch (e) {
      if (!silent || serviceCases.isEmpty) serviceCasesError = true;
      handleError(e.toString());
    } finally {
      isServiceCasesLoading = false;
      update();
    }
  }

  Future<void> getDocuments({bool silent = false}) async {
    try {
      if (!silent) {
        isDocumentsLoading = true;
        documentsError = false;
        update();
      }

      documents = await productRepo.getDocuments();
      documentsError = false;
    } catch (e) {
      if (!silent || documents.isEmpty) documentsError = true;
      handleError(e.toString());
    } finally {
      isDocumentsLoading = false;
      update();
    }
  }

  Future<bool> uploadDocument({
    required String productId,
    required String type,
    required File file,
  }) async {
    if (isUploadingDocument) return false;

    try {
      isUploadingDocument = true;
      update();

      final doc = await productRepo.uploadDocument(
        productId: productId,
        type: type,
        file: file,
      );

      documents = [doc, ...documents];
      handleSuccess('Document uploaded', showSuccessSnackBar: true);
      return true;
    } catch (e) {
      handleError(e.toString());
      return false;
    } finally {
      isUploadingDocument = false;
      update();
    }
  }

  Future<void> getCategories() async {
    try {
      isCategoriesLoading = true;
      categoriesError = false;
      update();

      categoriesModel = await productRepo.getCategories();
    } catch (e) {
      categoriesError = true;
      handleError(e.toString());
    } finally {
      isCategoriesLoading = false;
      update();
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String model,
    required String serialNumber,
  }) async {
    if (isUpdatingProduct) return false;

    try {
      isUpdatingProduct = true;
      update();

      await productRepo.updateProduct(
        id: id,
        model: model,
        serialNumber: serialNumber,
      );

      await getProductDetail(id: id);

      handleSuccess('Appliance updated', showSuccessSnackBar: true);
      return true;
    } catch (e) {
      handleError(e.toString());
      return false;
    } finally {
      isUpdatingProduct = false;
      update();
    }
  }

  Future<void> getManufacturers() async {
    try {
      isManufacturersLoading = true;
      manufacturersError = false;
      update();

      manufacturersModel = await productRepo.getManufacturers();
    } catch (e) {
      manufacturersError = true;
      handleError(e.toString());
    } finally {
      isManufacturersLoading = false;
      update();
    }
  }

  Future<bool> createProduct({
    required String categoryId,
    required String manufacturerId,
    required String model,
    required String purchasePrice,
    required String deliveryDate,
    required String serialNumber,
    File? photo,
  }) async {
    if (isCreatingProduct) return false;

    try {
      isCreatingProduct = true;
      update();

      await productRepo.createProduct(
        categoryId: categoryId,
        manufacturerId: manufacturerId,
        model: model,
        purchasePrice: purchasePrice,
        deliveryDate: deliveryDate,
        serialNumber: serialNumber,
        photo: photo,
      );

      handleSuccess('Appliance added', showSuccessSnackBar: true);

      // list refresh
      getProduct();
      getHomeSummary();

      return true;
    } catch (e) {
      handleError(e.toString());
      return false;
    } finally {
      isCreatingProduct = false;
      update();
    }
  }
}
