class ManufacturesModel {
  List<Manufacture>? data;

  ManufacturesModel({this.data});

  ManufacturesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Manufacture>[];

      json['data'].forEach((v) {
        data!.add(Manufacture.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((v) => v.toJson()).toList()};
  }
}

class Manufacture {
  String? id;
  String? name;

  Manufacture({this.id, this.name});

  Manufacture.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
