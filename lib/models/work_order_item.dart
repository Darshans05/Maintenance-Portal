class WorkOrderItem {
  final String aufnr;
  final String ktext;
  final String werks;
  final String status;
  final String equipment;
  final String functionalLocation;
  final String priority;

  WorkOrderItem({
    required this.aufnr,
    required this.ktext,
    required this.werks,
    required this.status,
    this.equipment = '',
    this.functionalLocation = '',
    this.priority = '',
  });

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) {
    return WorkOrderItem(
      aufnr: json['Aufnr'] ?? '',
      ktext: json['Ktext'] ?? '',
      werks: json['Werks'] ?? '',
      status: json['Status'] ?? '',
      equipment: json['Equnr'] ?? json['Equipment'] ?? '',
      functionalLocation: json['Tplnr'] ?? json['Func_loc'] ?? '',
      priority: json['Priokx'] ?? '',
    );
  }
}
