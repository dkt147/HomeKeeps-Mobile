import 'dart:io';

import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/data/network/network_api_service.dart';
import 'package:home_keeps/models/document_model.dart';
import 'package:home_keeps/models/home_summary_model.dart';
import 'package:home_keeps/models/manufactures_model.dart';
import 'package:home_keeps/models/product_category_model.dart';
import 'package:home_keeps/models/product_detail_model.dart';
import 'package:home_keeps/models/product_model.dart';
import 'package:home_keeps/models/service_case_detail_model.dart';
import 'package:home_keeps/models/service_case_model.dart';
import 'package:home_keeps/models/warranty_cases_model.dart';

class ProductRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future<ProductModel> getProduct() async {
    final response = await _apiService.get(AppUrl.product);

    return ProductModel.fromJson(response);
  }

  Future<HomeSummaryModel> getHomeSummary() async {
    final response = await _apiService.get(AppUrl.homeSummary);

    return HomeSummaryModel.fromJson(response['data']);
  }

  Future<WarrantyCaseStatusModel> getWarrantyCase() async {
    final response = await _apiService.get(AppUrl.warrrantyCase);

    return WarrantyCaseStatusModel.fromJson(response['data']);
  }

  Future<ProductDetailModel> getProductDetail({required String id}) async {
    final response = await _apiService.get("${AppUrl.productDetail}$id");

    return ProductDetailModel.fromJson(response);
  }

  Future<bool> deleteProduct({required String id}) async {
    final response = await _apiService.delete("${AppUrl.productDetail}$id");

    return response['data']?['archived'] == true;
  }

  Future<void> updateWarrantyReminder({
    required String id,
    required bool enabled,
  }) async {
    await _apiService.patch("${AppUrl.productDetail}$id/warranty-reminder", {
      "enabled": enabled,
    });
  }

  Future<List<String>> getFaultTypes({required String categoryId}) async {
    final response = await _apiService.get(
      "${AppUrl.productDetail}fault-types/$categoryId",
    );

    return List<String>.from(response['data'] ?? []);
  }

  Future<ServiceCaseResult> createServiceCase({
    required String productId,
    required String faultType,
    required String description,
    required List<dynamic> preferredSlots,
  }) async {
    final response = await _apiService
        .post("${AppUrl.productDetail}$productId/service-cases", {
          "product_id": productId,
          "fault_type": faultType,
          "description": description,
          "preferred_slots": preferredSlots,
        });

    return ServiceCaseResult.fromJson(response['data']);
  }

  Future<ServiceCaseModel> getServiceCase({required String caseId}) async {
    final response = await _apiService.get("${AppUrl.serviceCase}$caseId");

    return ServiceCaseModel.fromJson(response['data']);
  }

  Future<List<ServiceCaseModel>> getServiceCases() async {
    final response = await _apiService.get(AppUrl.serviceCases);

    final list = response['data'] as List? ?? [];
    return list
        .map((e) => ServiceCaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AppDocument>> getDocuments() async {
    final response = await _apiService.get(AppUrl.documents);

    final list = response['data'] as List? ?? [];
    return list
        .map((e) => AppDocument.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<AppDocument> uploadDocument({
    required String productId,
    required String type,
    required File file,
  }) async {
    final response = await _apiService.postMultipart(
      url: "${AppUrl.productDetail}$productId/documents",
      fields: {"type": type},
      files: {
        "file": [file],
      },
    );

    return AppDocument.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  Future<ProductCategoriesModel> getCategories() async {
    final response = await _apiService.get("${AppUrl.productDetail}categories");
    return ProductCategoriesModel.fromJson(response);
  }

  Future<ManufacturesModel> getManufacturers() async {
    final response = await _apiService.get(
      "${AppUrl.productDetail}manufacturers",
    );
    return ManufacturesModel.fromJson(response);
  }

  Future<void> updateProduct({
    required String id,
    required String model,
    required String serialNumber,
  }) async {
    await _apiService.patch("${AppUrl.productDetail}$id", {
      "model": model,
      "serial_number": serialNumber,
      // "purchase_date": ...,
    });
  }

  Future<void> createProduct({
    required String categoryId,
    required String manufacturerId,
    required String model,
    required String purchasePrice,
    required String deliveryDate,
    required String serialNumber,
    File? photo,
  }) async {
    await _apiService.postMultipart(
      url: AppUrl.product,
      fields: {
        "category_id": categoryId,
        "manufacturer_id": manufacturerId,
        "model": model,
        "purchase_price": purchasePrice,
        "delivery_date": deliveryDate,
        "serial_number": serialNumber,
      },
      files: photo != null
          ? {
              "photo": [photo],
            }
          : {},
    );
  }
}
