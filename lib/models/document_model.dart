class AppDocument {
  final String? id;
  final String? productId;
  final String? productName;
  final String? type;
  final String? originalFilename;
  final String? mime;
  final int? sizeBytes;
  final String? createdAt;
  final String? viewUrl;

  AppDocument({
    this.id,
    this.productId,
    this.productName,
    this.type,
    this.originalFilename,
    this.mime,
    this.sizeBytes,
    this.createdAt,
    this.viewUrl,
  });

  factory AppDocument.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    return AppDocument(
      id: json['_id']?.toString(),
      productId: json['product_id']?.toString(),
      productName: product is Map ? product['name']?.toString() : null,
      type: json['type']?.toString(),
      originalFilename: json['original_filename']?.toString(),
      mime: json['mime']?.toString(),
      sizeBytes: num.tryParse(json['size_bytes']?.toString() ?? '')?.toInt(),
      createdAt: json['created_at']?.toString(),
      viewUrl: json['view_url']?.toString(),
    );
  }
}
