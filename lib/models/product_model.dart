class ProductModel {
  final List<Product>? data;

  ProductModel({this.data});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      data: (json['data'] as List?)?.map((e) => Product.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }
}

class Product {
  final String? id;
  final String? householdId;
  final String? categoryId;
  final String? manufacturerId;
  final String? model;
  final String? serialNumber;
  final dynamic purchasePrice;
  final String? storeId;
  final String? purchaseDate;
  final String? deliveryDate;
  final String? status;
  final String? source;
  final int? healthScore;
  final String? healthState;
  final String? leadId;
  final String? serialNumberChangedAt;
  final String? purchaseDateChangedAt;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? warrantyLeft;
  final String? name;

  Product({
    this.id,
    this.householdId,
    this.categoryId,
    this.manufacturerId,
    this.model,
    this.serialNumber,
    this.purchasePrice,
    this.storeId,
    this.purchaseDate,
    this.deliveryDate,
    this.status,
    this.source,
    this.healthScore,
    this.healthState,
    this.leadId,
    this.serialNumberChangedAt,
    this.purchaseDateChangedAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.warrantyLeft,
    this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString(),
      householdId: json['household_id']?.toString(),
      categoryId: json['category_id']?.toString(),
      manufacturerId: json['manufacturer_id']?.toString(),
      model: json['model']?.toString(),
      serialNumber: json['serial_number']?.toString(),
      purchasePrice: json['purchase_price'],
      storeId: json['store_id']?.toString(),
      purchaseDate: json['purchase_date']?.toString(),
      deliveryDate: json['delivery_date']?.toString(),
      status: json['status']?.toString(),
      source: json['source']?.toString(),
      healthScore: json['health_score'],
      healthState: json['health_state']?.toString(),
      leadId: json['lead_id']?.toString(),
      serialNumberChangedAt: json['serial_number_changed_at']?.toString(),
      purchaseDateChangedAt: json['purchase_date_changed_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      warrantyLeft: json['warranty_left']?.toString(),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'household_id': householdId,
      'category_id': categoryId,
      'manufacturer_id': manufacturerId,
      'model': model,
      'serial_number': serialNumber,
      'purchase_price': purchasePrice,
      'store_id': storeId,
      'purchase_date': purchaseDate,
      'delivery_date': deliveryDate,
      'status': status,
      'source': source,
      'health_score': healthScore,
      'health_state': healthState,
      'lead_id': leadId,
      'serial_number_changed_at': serialNumberChangedAt,
      'purchase_date_changed_at': purchaseDateChangedAt,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'warranty_left': warrantyLeft,
      'name': name,
    };
  }
}
