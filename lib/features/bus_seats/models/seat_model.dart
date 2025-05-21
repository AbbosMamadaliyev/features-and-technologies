class SeatModel {
  final int id;
  final int row;
  final int column;
  final SeatType type;
  bool isSelected;
  bool isAvailable;

  SeatModel({
    required this.id,
    required this.row,
    required this.column,
    this.type = SeatType.regular,
    this.isSelected = false,
    this.isAvailable = true,
  });

  SeatModel copyWith({
    int? id,
    int? row,
    int? column,
    SeatType? type,
    bool? isSelected,
    bool? isAvailable,
  }) {
    return SeatModel(
      id: id ?? this.id,
      row: row ?? this.row,
      column: column ?? this.column,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

enum SeatType {
  regular,
  special,
  driver,
  empty
} 