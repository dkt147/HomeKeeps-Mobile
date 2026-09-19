class ServiceCaseResult {
  final bool created;
  final String? caseId;
  final String? status;

  ServiceCaseResult({required this.created, this.caseId, this.status});

  factory ServiceCaseResult.fromJson(Map<String, dynamic> json) {
    final caseJson =
        (json['existing_case'] ?? json['case'] ?? json['service_case'])
            as Map<String, dynamic>?;

    return ServiceCaseResult(
      created: json['created'] == true,
      caseId: (caseJson?['_id'] ?? json['_id'])?.toString(),
      status: caseJson?['status']?.toString(),
    );
  }
}
