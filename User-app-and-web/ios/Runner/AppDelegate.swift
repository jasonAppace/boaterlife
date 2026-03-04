import UIKit
import Flutter
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAWFKJ1njXCiIyV2cjG5kcO87xJyIK6GGM")
    // old key
    //GMSServices.provideAPIKey("AIzaSyAMpsf4Sciln5dDHQYbiyxQkPMYmfLqWBQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
