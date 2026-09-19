class HomeSummaryModel {
  final int? total;
  final int? underWarranty;
  final int? uncovered;
  final int? needsAction;

  HomeSummaryModel({
    this.total,
    this.underWarranty,
    this.uncovered,
    this.needsAction,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return HomeSummaryModel(
      total: json['total'] as int?,
      underWarranty: json['under_warranty'] as int?,
      uncovered: json['uncovered'] as int?,
      needsAction: json['needs_action'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'under_warranty': underWarranty,
      'uncovered': uncovered,
      'needs_action': needsAction,
    };
  }
}
