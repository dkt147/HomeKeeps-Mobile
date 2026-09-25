class OffersModel {
  OffersData? data;

  OffersModel({this.data});

  OffersModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      data = OffersData.fromJson(rawData);
    } else {
      data = null; // covers null, [], or any unexpected shape
    }
  }
}

class OffersData {
  String? result;
  String? suppressedBy;
  String? productId;
  int? productAgeMonths;
  List<Offer>? offers;
  ServiceFirst? serviceFirst;

  OffersData({
    this.result,
    this.suppressedBy,
    this.productId,
    this.productAgeMonths,
    this.offers,
    this.serviceFirst,
  });

  OffersData.fromJson(Map<String, dynamic> json) {
    result = json['result']?.toString();
    suppressedBy = json['suppressed_by']?.toString();
    productId = json['product_id']?.toString();
    productAgeMonths = json['product_age_months'];

    if (json['offers'] != null) {
      offers = <Offer>[];
      (json['offers'] as List).forEach((v) {
        offers!.add(Offer.fromJson(Map<String, dynamic>.from(v)));
      });
    }

    serviceFirst = json['service_first'] != null
        ? ServiceFirst.fromJson(json['service_first'])
        : null;
  }

  bool get isAvailable =>
      result == 'available' && (offers?.isNotEmpty ?? false);
}

class Offer {
  String? id;
  String? planId;
  String? name;
  String? description;
  String? categoryId;
  int? durationMonths;
  int? price; // smallest currency unit, e.g. agorot
  String? currency;
  String? amountUnit;
  int? deductible;
  int? waitingPeriodDays;
  int? maxClaims;
  int? termsVersion;
  OfferTerms? terms;
  List<String>? exclusions;
  Eligibility? eligibility;

  Offer({
    this.id,
    this.planId,
    this.name,
    this.description,
    this.categoryId,
    this.durationMonths,
    this.price,
    this.currency,
    this.amountUnit,
    this.deductible,
    this.waitingPeriodDays,
    this.maxClaims,
    this.termsVersion,
    this.terms,
    this.exclusions,
    this.eligibility,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    planId = json['plan_id']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    categoryId = json['category_id']?.toString();
    durationMonths = json['duration_months'];
    price = json['price'];
    currency = json['currency']?.toString();
    amountUnit = json['amount_unit']?.toString();
    deductible = json['deductible'];
    waitingPeriodDays = json['waiting_period_days'];
    maxClaims = json['max_claims'];
    termsVersion = json['terms_version'];

    terms = json['terms'] != null
        ? OfferTerms.fromJson(Map<String, dynamic>.from(json['terms']))
        : null;

    if (json['exclusions'] != null) {
      exclusions = List<String>.from(json['exclusions']);
    }

    eligibility = json['eligibility'] != null
        ? Eligibility.fromJson(Map<String, dynamic>.from(json['eligibility']))
        : null;
  }

  // price is in the smallest unit (agorot); convert to whole currency units
  double get priceInCurrency => (price ?? 0) / 100;

  int get years => ((durationMonths ?? 0) / 12).round();

  double get monthlyPrice =>
      (durationMonths ?? 0) == 0 ? 0 : priceInCurrency / durationMonths!;
}

class OfferTerms {
  String? title;
  String? summary;

  OfferTerms({this.title, this.summary});

  OfferTerms.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    summary = json['summary']?.toString();
  }
}

class Eligibility {
  bool? eligible;
  String? reason;

  Eligibility({this.eligible, this.reason});

  Eligibility.fromJson(Map<String, dynamic> json) {
    eligible = json['eligible'];
    reason = json['reason']?.toString();
  }
}

class ServiceFirst {
  bool? blocked;
  String? message;
  dynamic caseData;

  ServiceFirst({this.blocked, this.message, this.caseData});

  ServiceFirst.fromJson(Map<String, dynamic> json) {
    blocked = json['blocked'];
    message = json['message']?.toString();
    caseData = json['case'];
  }
}
