import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    notificationAuthorization()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
//  func notificationAuthorization() {
//    let notificationCenter = UNUserNotificationCenter.current()
//    notificationCenter.delegate = self
//    notificationCenter.requestAuthorization(options: [.alert,.sound]) {(accepted, error) in
//      if !accepted {
//        print("Notification access denied")
//      }
//    }
//  }
//
//  override func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    willPresent notification: UNNotification,
//    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//  ) {
//    completionHandler( [.alert, .badge, .sound])
//  }
//
//  override func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void
//  ) {
//    completionHandler()
//  }
}
