import Flutter
import UIKit
import CallKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    let callObserver = CXCallObserver()
    var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "call_status", binaryMessenger: controller.binaryMessenger)

        callObserver.setDelegate(self, queue: nil)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded {
            methodChannel?.invokeMethod("CALL_IDLE", arguments: nil)
        } else if call.isOutgoing || call.hasConnected {
            methodChannel?.invokeMethod("CALL_OFFHOOK", arguments: nil)
        } else if !call.hasConnected {
            methodChannel?.invokeMethod("CALL_RINGING", arguments: nil)
        }
    }
}
