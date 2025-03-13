import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockExamplePage extends StatefulWidget {
  const LockExamplePage({super.key});

  @override
  State<LockExamplePage> createState() => _LockExamplePageState();
}

class _LockExamplePageState extends State<LockExamplePage> {
  static const MethodChannel _channel = MethodChannel('call_status');
  String callStatus = "CALL_IDLE"; // To'g'ri boshlang'ich qiymat

  @override
  void initState() {
    super.initState();
    _listenCallStatus();
  }

  void _listenCallStatus() {
    _channel.setMethodCallHandler((call) async {
      print('===== Keldi: ${call.method}');
      if (call.method == "CALL_RINGING" || call.method == "CALL_OFFHOOK") {
        setState(() {
          callStatus = call.method;
        });
      } else {
        setState(() {
          callStatus = "CALL_IDLE";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Flutter Demo Home Page')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('You have pushed the button this many times:'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
        if (callStatus == "CALL_RINGING" || callStatus == "CALL_OFFHOOK")
          Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Text(
                  'Ilova oynasi bloklandi',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
