

class FineDetail {
  final String fineType;
  final String fineAmount;
  final String notes;

  FineDetail({
    required this.fineType,
    required this.fineAmount,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'fineType': fineType,
      'fineAmount': fineAmount,
      'notes': notes,
    };
  }

  factory FineDetail.fromJson(Map<String, dynamic> json) {
    return FineDetail(
      fineType: json['fineType'],
      fineAmount: json['fineAmount'],
      notes: json['notes'],
    );
  }
}
class assignedFineDetail {
  final String fineType;
  final String fineAmount;
  final String notes;
  final String assignedDrivers;

  assignedFineDetail( {
    required this.fineType,
    required this.fineAmount,
    required this.notes,
    required this.assignedDrivers,
  });

  Map<String, dynamic> toJson() {
    return {
      'fineType': fineType,
      'fineAmount': fineAmount,
      'notes': notes,
      'assignedDrivers':assignedDrivers
    };
  }

  factory assignedFineDetail.fromJson(Map<String, dynamic> json) {
    return assignedFineDetail(
      fineType: json['fineType'],
      fineAmount: json['fineAmount'],
      notes: json['notes'],
      assignedDrivers: json['assignedDrivers'],

    );
  }
}