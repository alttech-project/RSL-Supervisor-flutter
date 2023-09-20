import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyBdqEy6MU7Th1WWKnfckzEDqJG4CWShBvk")

        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    


    
    
}
