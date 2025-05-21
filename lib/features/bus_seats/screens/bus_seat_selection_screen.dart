import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import '../services/bus_layout_generator.dart';
import '../widgets/bus_layout.dart';

class BusSeatSelectionScreen extends StatefulWidget {
  const BusSeatSelectionScreen({Key? key}) : super(key: key);

  @override
  State<BusSeatSelectionScreen> createState() => _BusSeatSelectionScreenState();
}

class _BusSeatSelectionScreenState extends State<BusSeatSelectionScreen> {
  late List<SeatModel> seats;
  String selectedLayout = 'standard';

  @override
  void initState() {
    super.initState();
    seats = BusLayoutGenerator.generateStandardBusLayout();
  }

  void _onSeatTap(SeatModel seat) {
    setState(() {
      final index = seats.indexWhere((s) => s.id == seat.id);
      seats[index] = seats[index].copyWith(
        isSelected: !seats[index].isSelected,
      );
    });
  }

  void _changeLayout(String layout) {
    setState(() {
      selectedLayout = layout;
      seats = switch (layout) {
        'standard' => BusLayoutGenerator.generateStandardBusLayout(),
        'mini' => BusLayoutGenerator.generateMiniBusLayout(),
        'luxury' => BusLayoutGenerator.generateLuxuryBusLayout(),
        _ => BusLayoutGenerator.generateStandardBusLayout(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avtobus o\'rindiqlari'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeLayout,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'standard',
                child: Text('Standart avtobus'),
              ),
              const PopupMenuItem(
                value: 'mini',
                child: Text('Mini avtobus'),
              ),
              const PopupMenuItem(
                value: 'luxury',
                child: Text('Lyuks avtobus'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BusLayout(
                    seats: seats,
                    onSeatTap: _onSeatTap,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(Colors.white, 'Bo\'sh'),
                  _buildLegendItem(Colors.green, 'Band'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: color == Colors.green 
              ? const Icon(Icons.person, color: Colors.white, size: 16)
              : null,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
} 