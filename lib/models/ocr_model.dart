class OcrPriceModel {
  final double? value;
  final String? currency;
  final int? agorot;

  OcrPriceModel({this.value, this.currency, this.agorot});

  factory OcrPriceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OcrPriceModel();
    return OcrPriceModel(
      value: (json['value'] as num?)?.toDouble(),
      currency: json['currency'],
      agorot: json['agorot'],
    );
  }
}

class OcrExtractedFields {
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final OcrPriceModel? purchasePrice;
  final String? purchaseDate;
  final String? delievryDate;
  final String? storeName;

  OcrExtractedFields({
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.purchasePrice,
    this.purchaseDate,
    this.delievryDate,
    this.storeName,
  });

  factory OcrExtractedFields.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OcrExtractedFields();
    return OcrExtractedFields(
      manufacturer: json['manufacturer'],
      model: json['model'],
      serialNumber: json['serial_number'],
      purchasePrice: OcrPriceModel.fromJson(json['purchase_price']),
      purchaseDate: json['purchase_date'],
      delievryDate: json['delievry_date'],
      storeName: json['store_name'],
    );
  }
}

class OcrJobModel {
  final String jobId;
  final String type;
  final String status;
  final String? fileName;
  final String? errorCode;
  final String? errorMessage;
  final OcrExtractedFields? extracted;

  OcrJobModel({
    required this.jobId,
    required this.type,
    required this.status,
    this.fileName,
    this.errorCode,
    this.errorMessage,
    this.extracted,
  });

  bool get isProcessing => status == 'queued' || status == 'processing';
  bool get isReadyForReview => status == 'completed';
  bool get isConfirmed => status == 'confirmed';
  bool get isFailed => status == 'failed';

  factory OcrJobModel.fromJson(Map<String, dynamic> json) {
    return OcrJobModel(
      jobId: json['job_id'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      fileName: json['file_name'],
      errorCode: json['error_code'],
      errorMessage: json['error_message'],
      extracted: json['extracted'] != null
          ? OcrExtractedFields.fromJson(json['extracted']['fields'])
          : null,
    );
  }
}
