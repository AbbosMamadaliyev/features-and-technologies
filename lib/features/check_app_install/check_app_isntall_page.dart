import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckAppInstallPage extends StatefulWidget {
  const CheckAppInstallPage({super.key});

  @override
  State<CheckAppInstallPage> createState() => _CheckAppInstallPageState();
}

class _CheckAppInstallPageState extends State<CheckAppInstallPage> {
  static const MethodChannel _channel = MethodChannel('com.example/checkInstagram');

  @override
  void initState() {
    super.initState();
  }

  void checkAppInstallFromPackage() async {
    if (Platform.isAndroid) {
      try {
        bool? isInstalled = await InstalledApps.isAppInstalled('ge.space.app.uzbekistan');
        print('isInstalled: $isInstalled');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void checkAppInstallFromChannel() async {
    if (Platform.isAndroid) {
      try {
        final bool isInstalled = await _channel.invokeMethod('isInstagramInstalled');
        setState(() {
          print('isInstalled: $isInstalled');
        });
      } on PlatformException catch (e) {
        print('PlatformException: $e');
      }
    }
  }

  Future<bool> isAppInstalled(String urlScheme) async {
    return await canLaunchUrl(Uri.parse(urlScheme));
  }

  void checkApp() async {
    bool installed = await isAppInstalled("sharh://");
    if (installed) {
      print("****** APP installed ******");
    } else {
      print("====== NOT install =======");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check App Install Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Check App Install Page'),
            ElevatedButton(
              onPressed: () {
                if (Platform.isIOS) {
                  checkApp();
                  return;
                }

                // checkAppInstallFromPackage();

                checkAppInstallFromChannel();
              },
              child: Text('Check App Install'),
            ),
          ],
        ),
      ),
    );
  }
}
