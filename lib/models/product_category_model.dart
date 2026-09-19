class ProductCategoriesModel {
  List<ProductCategory>? data;

  ProductCategoriesModel({this.data});

  ProductCategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductCategory>[];

      json['data'].forEach((v) {
        data!.add(ProductCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((v) => v.toJson()).toList()};
  }
}

class ProductCategory {
  String? id;
  String? name;
  int? avgLifespanMonths;
  bool? isInsurable;

  ProductCategory({
    this.id,
    this.name,
    this.avgLifespanMonths,
    this.isInsurable,
  });

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    avgLifespanMonths = json['avg_lifespan_months'];
    isInsurable = json['is_insurable'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'avg_lifespan_months': avgLifespanMonths,
      'is_insurable': isInsurable,
    };
  }
}
