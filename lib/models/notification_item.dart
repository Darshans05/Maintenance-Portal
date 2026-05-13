class NotificationItem {
  final String qmNum;
  final String qmTxt;
  final String priority;
  final String status;
  final String date;
  final String createdBy;
  final String plant;
  final String equipment;
  final String notificationType;
  final String category;

  NotificationItem({
    required this.qmNum,
    required this.qmTxt,
    required this.priority,
    required this.status,
    this.date = '',
    this.createdBy = '',
    this.plant = '',
    this.equipment = '',
    this.notificationType = '',
    this.category = '',
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      qmNum: json['Qmnum'] ?? '',
      qmTxt: json['Qmtxt'] ?? '',
      priority: json['Priokx'] ?? json['Priok'] ?? '',
      status: json['Status'] ?? '',
      date: json['Erdat'] ?? '',
      createdBy: json['Ernam'] ?? '',
      plant: json['Iwerk'] ?? '',
      equipment: json['Equnr'] ?? '',
      notificationType: json['Qmart'] ?? '',
      category: json['Artpr'] ?? '',
    );
  }

  String get formattedDate {
    if (date.isEmpty) return '';
    final match = RegExp(r'\/(Date\((\d+)\))\/').firstMatch(date);
    if (match == null) return date;
    final epoch = int.tryParse(match.group(2) ?? '0');
    if (epoch == null) return date;
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch, isUtc: true).toLocal();
    return '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';
  }

  static String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month - 1];
  }
}
