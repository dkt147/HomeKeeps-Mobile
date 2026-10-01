class StoresModel {
  final List<StoreModel>? data;

  StoresModel({this.data});

  factory StoresModel.fromJson(Map<String, dynamic> json) {
    return StoresModel(
      data: (json['data'] as List?)
          ?.map((e) => StoreModel.fromJson(e))
          .toList(),
    );
  }
}

class StoreModel {
  final String? id;
  final String? name;

  StoreModel({this.id, this.name});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }
}
