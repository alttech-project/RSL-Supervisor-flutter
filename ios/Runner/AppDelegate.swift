import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyBdqEy6MU7Th1WWKnfckzEDqJG4CWShBvk")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.requestTrackingPermission()
        }
    }
    
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("App tracking status: Authorized")
                case .denied:
                    print("App tracking status: Denied")
                case .notDetermined:
                    print("App tracking status: Not Determined")
                case .restricted:
                    print("App tracking status: Restricted")
                @unknown default:
                    print("App tracking status: Unknown")
                }
            }
        }
        else {
        }
    }
    
}
