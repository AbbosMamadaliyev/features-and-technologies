import '../models/seat_model.dart';

class BusLayoutGenerator {
  static List<SeatModel> generateLayout({
    required int rows,
    required int doorStartRow,
    required int doorEndRow,
    List<int>? unavailableSeats,
  }) {
    final List<SeatModel> seats = [];
    int seatId = 1;

    // Generate passenger seats
    for (int i = 0; i < rows; i++) {
      // Left pair (always present)
      seats.add(SeatModel(
        id: seatId++,
        row: i,
        column: 0,
        isAvailable: !(unavailableSeats?.contains(seatId - 1) ?? false),
      ));
      seats.add(SeatModel(
        id: seatId++,
        row: i,
        column: 1,
        isAvailable: !(unavailableSeats?.contains(seatId - 1) ?? false),
      ));

      // Right pair (skip if door area)
      if (i < doorStartRow || i > doorEndRow) {
        seats.add(SeatModel(
          id: seatId++,
          row: i,
          column: 2,
          isAvailable: !(unavailableSeats?.contains(seatId - 1) ?? false),
        ));
        seats.add(SeatModel(
          id: seatId++,
          row: i,
          column: 3,
          isAvailable: !(unavailableSeats?.contains(seatId - 1) ?? false),
        ));
      }
    }

    return seats;
  }

  // Predefined layouts
  static List<SeatModel> generateStandardBusLayout() {
    return generateLayout(
      rows: 13,
      doorStartRow: 5,  // Door starts at 6th row
      doorEndRow: 6,    // Door ends at 7th row
      unavailableSeats: [5, 12, 25, 38], // Some seats are already taken
    );
  }

  static List<SeatModel> generateMiniBusLayout() {
    return generateLayout(
      rows: 8,
      doorStartRow: 3,
      doorEndRow: 4,
      unavailableSeats: [3, 8, 15],
    );
  }

  static List<SeatModel> generateLuxuryBusLayout() {
    return generateLayout(
      rows: 10,
      doorStartRow: 4,
      doorEndRow: 5,
      unavailableSeats: [4, 7, 18, 22],
    );
  }
} 