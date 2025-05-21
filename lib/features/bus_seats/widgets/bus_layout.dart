import 'package:flutter/material.dart';
import '../models/seat_model.dart';

class BusLayout extends StatelessWidget {
  final List<SeatModel> seats;
  final Function(SeatModel) onSeatTap;
  final double seatSize;
  final double spacing;

  const BusLayout({
    Key? key,
    required this.seats,
    required this.onSeatTap,
    this.seatSize = 50,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double calculatedSeatSize = 
            (availableWidth - (spacing * 3)) / 4; // 4 seats in a row (2 pairs)
        final double actualSeatSize = calculatedSeatSize < seatSize 
            ? calculatedSeatSize 
            : seatSize;

        // Group seats by rows
        Map<int, List<SeatModel>> rowSeats = {};
        for (var seat in seats) {
          rowSeats.putIfAbsent(seat.row, () => []);
          rowSeats[seat.row]!.add(seat);
        }

        // Sort rows
        final sortedRows = rowSeats.keys.toList()..sort();

        return Column(
          children: sortedRows.map((rowNum) {
            final rowSeatsList = rowSeats[rowNum]!;
            
            // Split into left and right pairs
            List<SeatModel> leftPair = [];
            List<SeatModel> rightPair = [];
            
            for (var seat in rowSeatsList) {
              if (seat.column < 2) {
                leftPair.add(seat);
              } else {
                rightPair.add(seat);
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left pair
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: leftPair.map((seat) => 
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing / 4),
                          child: _buildSeat(seat, actualSeatSize),
                        ),
                      ).toList(),
                    ),
                  ),
                  // Center aisle
                  SizedBox(width: spacing * 2),
                  // Right pair or empty space for door
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rightPair.isEmpty 
                          ? [
                              Container(
                                width: actualSeatSize * 2 + spacing / 2,
                                height: actualSeatSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'ESHIK',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : rightPair.map((seat) => 
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: spacing / 4),
                                child: _buildSeat(seat, actualSeatSize),
                              ),
                            ).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSeat(SeatModel seat, double size) {
    return GestureDetector(
      onTap: () {
        if (seat.isAvailable && seat.type != SeatType.empty) {
          onSeatTap(seat);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getSeatColor(seat),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: seat.isSelected || !seat.isAvailable
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: size * 0.6,
                )
              : Text(
                  seat.id.toString(),
                  style: TextStyle(
                    color: _getTextColor(seat),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Color _getSeatColor(SeatModel seat) {
    if (!seat.isAvailable) return Colors.green;
    if (seat.type == SeatType.empty) return Colors.transparent;
    if (seat.type == SeatType.driver) return Colors.blue.shade100;
    if (seat.isSelected) return Colors.green;
    return Colors.white;
  }

  Color _getTextColor(SeatModel seat) {
    if (!seat.isAvailable || seat.type == SeatType.empty) return Colors.grey;
    if (seat.isSelected) return Colors.white;
    return Colors.black;
  }
} 