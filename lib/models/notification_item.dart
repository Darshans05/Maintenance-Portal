class NotificationItem {
  final String qmNum;
  final String qmTxt;
  final String priority;
  final String status;
  final String date;
  final String createdBy;

  NotificationItem({
    required this.qmNum,
    required this.qmTxt,
    required this.priority,
    required this.status,
    this.date = '',
    this.createdBy = '',
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      qmNum: json['Qmnum'] ?? '',
      qmTxt: json['Qmtxt'] ?? '',
      priority: json['Priokx'] ?? '',
      status: json['Status'] ?? '',
      date: json['Erdat'] ?? '', // Format varies depending on SAP response
      createdBy: json['Ernam'] ?? '',
    );
  }
}
