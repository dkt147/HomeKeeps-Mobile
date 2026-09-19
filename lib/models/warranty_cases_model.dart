class WarrantyCaseStatusModel {
  final String? action;
  final bool? commercial;
  final String? suppressedBy;
  final String? productId;
  final String? caseId;
  final WarrantyProductModel? product;
  final ManufacturerWarrantyModel? manufacturerWarranty;
  final String? reason;

  WarrantyCaseStatusModel({
    this.action,
    this.commercial,
    this.suppressedBy,
    this.productId,
    this.caseId,
    this.product,
    this.manufacturerWarranty,
    this.reason,
  });

  factory WarrantyCaseStatusModel.fromJson(Map<String, dynamic> json) {
    return WarrantyCaseStatusModel(
      action: json['action'] as String?,
      commercial: json['commercial'] as bool?,
      suppressedBy: json['suppressed_by'] as String?,
      productId: json['product_id'] as String?,
      caseId: json['case_id'] as String?,
      product: json['product'] != null
          ? WarrantyProductModel.fromJson(json['product'])
          : null,
      manufacturerWarranty: json['manufacturer_warranty'] != null
          ? ManufacturerWarrantyModel.fromJson(json['manufacturer_warranty'])
          : null,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'commercial': commercial,
      'suppressed_by': suppressedBy,
      'product_id': productId,
      'case_id': caseId,
      'product': product?.toJson(),
      'manufacturer_warranty': manufacturerWarranty?.toJson(),
      'reason': reason,
    };
  }
}

class WarrantyProductModel {
  final String? id;
  final String? manufacturerName;
  final String? categoryName;
  final String? model;

  WarrantyProductModel({
    this.id,
    this.manufacturerName,
    this.categoryName,
    this.model,
  });

  factory WarrantyProductModel.fromJson(Map<String, dynamic> json) {
    return WarrantyProductModel(
      id: json['id'] as String?,
      manufacturerName: json['manufacturer_name'] as String?,
      categoryName: json['category_name'] as String?,
      model: json['model'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturer_name': manufacturerName,
      'category_name': categoryName,
      'model': model,
    };
  }
}

class ManufacturerWarrantyModel {
  final String? endDate;
  final int? daysRemaining;

  ManufacturerWarrantyModel({this.endDate, this.daysRemaining});

  factory ManufacturerWarrantyModel.fromJson(Map<String, dynamic> json) {
    return ManufacturerWarrantyModel(
      endDate: json['end_date'] as String?,
      daysRemaining: json['days_remaining'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'end_date': endDate, 'days_remaining': daysRemaining};
  }
}
