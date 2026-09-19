class ProductDetailModel {
  ProductDetailData? data;

  ProductDetailModel({this.data});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? ProductDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class ProductDetailData {
  String? id;
  String? householdId;
  String? categoryId;
  String? manufacturerId;
  String? model;
  String? serialNumber;
  dynamic purchasePrice;
  dynamic storeId;
  String? purchaseDate;
  dynamic deliveryDate;
  String? status;
  String? source;
  int? healthScore;
  String? healthState;
  String? leadId;
  String? serialNumberChangedAt;
  String? purchaseDateChangedAt;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? warrantyReminderEnabled;
  String? name;

  Category? category;
  Manufacturer? manufacturer;
  dynamic store;
  Purchase? purchase;
  ManufacturerWarranty? manufacturerWarranty;
  List<ExtendedWarranty>? extendedWarranties;
  Warranty? warranty;
  String? warrantyLeft;
  List<DocumentModel>? documents;
  List<ServiceHistory>? serviceHistory;
  WarrantyReminder? warrantyReminder;

  ProductDetailData({
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
    this.warrantyReminderEnabled,
    this.name,
    this.category,
    this.manufacturer,
    this.store,
    this.purchase,
    this.manufacturerWarranty,
    this.extendedWarranties,
    this.warranty,
    this.warrantyLeft,
    this.documents,
    this.serviceHistory,
    this.warrantyReminder,
  });

  ProductDetailData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    householdId = json['household_id'];
    categoryId = json['category_id'];
    manufacturerId = json['manufacturer_id'];
    model = json['model'];
    serialNumber = json['serial_number'];
    purchasePrice = json['purchase_price'];
    storeId = json['store_id'];
    purchaseDate = json['purchase_date'];
    deliveryDate = json['delivery_date'];
    status = json['status'];
    source = json['source'];
    healthScore = json['health_score'];
    healthState = json['health_state'];
    leadId = json['lead_id'];
    serialNumberChangedAt = json['serial_number_changed_at'];
    purchaseDateChangedAt = json['purchase_date_changed_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warrantyReminderEnabled = json['warranty_reminder_enabled'];
    name = json['name'];

    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;

    manufacturer = json['manufacturer'] != null
        ? Manufacturer.fromJson(json['manufacturer'])
        : null;

    purchase = json['purchase'] != null
        ? Purchase.fromJson(json['purchase'])
        : null;

    manufacturerWarranty = json['manufacturer_warranty'] != null
        ? ManufacturerWarranty.fromJson(json['manufacturer_warranty'])
        : null;

    if (json['extended_warranties'] != null) {
      extendedWarranties = <ExtendedWarranty>[];
      json['extended_warranties'].forEach((v) {
        extendedWarranties!.add(ExtendedWarranty.fromJson(v));
      });
    }

    warranty = json['warranty'] != null
        ? Warranty.fromJson(json['warranty'])
        : null;

    warrantyLeft = json['warranty_left'];

    if (json['documents'] != null) {
      documents = <DocumentModel>[];
      json['documents'].forEach((v) {
        documents!.add(DocumentModel.fromJson(v));
      });
    }

    if (json['service_history'] != null) {
      serviceHistory = <ServiceHistory>[];
      json['service_history'].forEach((v) {
        serviceHistory!.add(ServiceHistory.fromJson(v));
      });
    }

    warrantyReminder = json['warranty_reminder'] != null
        ? WarrantyReminder.fromJson(json['warranty_reminder'])
        : null;
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
      'warranty_reminder_enabled': warrantyReminderEnabled,
      'name': name,
      'category': category?.toJson(),
      'manufacturer': manufacturer?.toJson(),
      'purchase': purchase?.toJson(),
      'manufacturer_warranty': manufacturerWarranty?.toJson(),
      'extended_warranties': extendedWarranties
          ?.map((e) => e.toJson())
          .toList(),
      'warranty': warranty?.toJson(),
      'warranty_left': warrantyLeft,
      'documents': documents?.map((e) => e.toJson()).toList(),
      'service_history': serviceHistory?.map((e) => e.toJson()).toList(),
      'warranty_reminder': warrantyReminder?.toJson(),
    };
  }
}

class Category {
  String? id;
  String? name;
  int? avgLifespanMonths;
  bool? isInsurable;

  Category({this.id, this.name, this.avgLifespanMonths, this.isInsurable});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avgLifespanMonths = json['avg_lifespan_months'];
    isInsurable = json['is_insurable'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avg_lifespan_months': avgLifespanMonths,
    'is_insurable': isInsurable,
  };
}

class Manufacturer {
  String? id;
  String? name;
  String? supportPhone;
  String? termsUrl;

  Manufacturer({this.id, this.name, this.supportPhone, this.termsUrl});

  Manufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    supportPhone = json['support_phone'];
    termsUrl = json['terms_url'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'support_phone': supportPhone,
    'terms_url': termsUrl,
  };
}

class Purchase {
  String? date;
  dynamic price;
  dynamic store;

  Purchase({this.date, this.price, this.store});

  Purchase.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    price = json['price'];
    store = json['store'];
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'price': price,
    'store': store,
  };
}

class ManufacturerWarranty {
  String? id;
  String? productId;
  String? createdAt;
  String? endDate;
  dynamic serviceProviderId;
  String? source;
  String? startDate;
  String? termsUrl;
  String? updatedAt;

  ManufacturerWarranty.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    endDate = json['end_date'];
    serviceProviderId = json['service_provider_id'];
    source = json['source'];
    startDate = json['start_date'];
    termsUrl = json['terms_url'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {};
}

class Warranty {
  String? status;
  String? message;
  String? startDate;
  String? endDate;
  int? daysRemaining;
  dynamic provider;
  int? customerPays;
  bool? dispatch;

  Warranty.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    daysRemaining = json['days_remaining'];
    provider = json['provider'];
    customerPays = json['customer_pays'];
    dispatch = json['dispatch'];
  }

  Map<String, dynamic> toJson() => {};
}

class ServiceHistory {
  String? id;
  String? coverageSource;
  String? faultType;
  String? description;
  String? status;
  String? scheduledAt;
  String? slaDueAt;
  String? closedAt;
  String? resolution;
  int? csatScore;
  String? createdAt;
  String? updatedAt;

  ServiceHistory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    coverageSource = json['coverage_source'];
    faultType = json['fault_type'];
    description = json['description'];
    status = json['status'];
    scheduledAt = json['scheduled_at'];
    slaDueAt = json['sla_due_at'];
    closedAt = json['closed_at'];
    resolution = json['resolution'];
    csatScore = json['csat_score'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {};
}

class WarrantyReminder {
  bool? enabled;

  WarrantyReminder({this.enabled});

  WarrantyReminder.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() => {'enabled': enabled};
}

class ExtendedWarranty {
  ExtendedWarranty();

  ExtendedWarranty.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}

class DocumentModel {
  DocumentModel();

  DocumentModel.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {};
}
