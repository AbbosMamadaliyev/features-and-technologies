import 'package:flutter/material.dart';
import 'package:flutter_radio_player/data/flutter_radio_player_event.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final _flutterRadioPlayerPlugin = FlutterRadioPlayer(); // Create an instance of the player

  @override
  initState() {
    super.initState();

    _flutterRadioPlayerPlugin.initialize(
      [
        {"url": "https://servidor26.brlogic.com:8652/live"},
      ],
      true, // Auto play on load
    ).then(
      (value) {
        // Handle successful initialization
        print("Radio player initialized successfully");
      },
    ).catchError(
      (error) {
        // Handle initialization error
        print("Error initializing radio player: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Add your action here

                try {
                  await _flutterRadioPlayerPlugin.play();
                } catch (e) {
                  print('Error playing radio: $e');
                }

                print('Playing radio...');
              },
              child: const Text('Click Me for play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add your action here

                try {
                  await _flutterRadioPlayerPlugin.pause();
                } catch (e) {
                  print('Error playing radio: $e');
                }

                print('Playing radio...');
              },
              child: const Text('Click Me for pause'),
            ),
          ],
        ),
      ),
    );
  }
}
