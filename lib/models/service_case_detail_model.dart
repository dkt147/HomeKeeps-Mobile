class ServiceCaseModel {
  final String? id;
  final String? productId;
  final String? coverageSource;
  final String? faultType;
  final String? description;
  final String? status;
  final String? technicianName;
  final String? scheduledAt;
  final String? closedAt;
  final String? createdAt;
  final String? updatedAt;
  final num? chargedToCustomer;
  final List<String> preferredSlots;
  final List<CaseTimelineEvent> timeline;

  ServiceCaseModel({
    this.id,
    this.productId,
    this.coverageSource,
    this.faultType,
    this.description,
    this.status,
    this.technicianName,
    this.scheduledAt,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
    this.chargedToCustomer,
    this.preferredSlots = const [],
    this.timeline = const [],
  });

  // Backend ke closed status ka naam alag ho to yahan badlein
  bool get isClosed => closedAt != null || status == 'closed';

  factory ServiceCaseModel.fromJson(Map<String, dynamic> json) {
    return ServiceCaseModel(
      id: json['_id']?.toString(),
      productId: json['product_id']?.toString(),
      coverageSource: json['coverage_source']?.toString(),
      faultType: json['fault_type']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      technicianName: json['technician_name']?.toString(),
      scheduledAt: json['scheduled_at']?.toString(),
      closedAt: json['closed_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      chargedToCustomer: num.tryParse(
        json['charged_to_customer']?.toString() ?? '',
      ),
      preferredSlots: (json['preferred_slots'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      timeline: (json['timeline'] as List? ?? [])
          .whereType<Map>()
          .map((e) => CaseTimelineEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class CaseTimelineEvent {
  final String? id;
  final String? type;
  final String? actorType;
  final String? createdAt;
  final Map<String, dynamic> payload;

  CaseTimelineEvent({
    this.id,
    this.type,
    this.actorType,
    this.createdAt,
    this.payload = const {},
  });

  // status_changed event mein naya status
  String? get toStatus => payload['to']?.toString();

  factory CaseTimelineEvent.fromJson(Map<String, dynamic> json) {
    return CaseTimelineEvent(
      id: json['_id']?.toString(),
      type: json['type']?.toString(),
      actorType: json['actor_type']?.toString(),
      createdAt: json['created_at']?.toString(),
      payload: json['payload'] is Map
          ? Map<String, dynamic>.from(json['payload'])
          : {},
    );
  }
}
