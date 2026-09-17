class ProfileModel {
  final Customer? customer;
  final Household? household;

  ProfileModel({this.customer, this.household});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      household: json['household'] != null
          ? Household.fromJson(json['household'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'customer': customer?.toJson(), 'household': household?.toJson()};
  }
}

class Customer {
  final String? id;
  final String? phone;
  final String? fullName;
  final String? email;
  final String? status;
  final String? source;
  final bool? consentService;
  final bool? consentMarketing;
  final String? consentMarketingAt;
  final String? lastLoginAt;

  Customer({
    this.id,
    this.phone,
    this.fullName,
    this.email,
    this.status,
    this.source,
    this.consentService,
    this.consentMarketing,
    this.consentMarketingAt,
    this.lastLoginAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString(),
      phone: json['phone']?.toString(),
      fullName: json['full_name']?.toString(),
      email: json['email']?.toString(),
      status: json['status']?.toString(),
      source: json['source']?.toString(),
      consentService: json['consent_service'],
      consentMarketing: json['consent_marketing'],
      consentMarketingAt: json['consent_marketing_at']?.toString(),
      lastLoginAt: json['last_login_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'email': email,
      'status': status,
      'source': source,
      'consent_service': consentService,
      'consent_marketing': consentMarketing,
      'consent_marketing_at': consentMarketingAt,
      'last_login_at': lastLoginAt,
    };
  }
}

class Household {
  final String? id;
  final String? name;
  final String? city;
  final String? addressLine;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Household({
    this.id,
    this.name,
    this.city,
    this.addressLine,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Household.fromJson(Map<String, dynamic> json) {
    return Household(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      city: json['city']?.toString(),
      addressLine: json['address_line']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'city': city,
      'address_line': addressLine,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
