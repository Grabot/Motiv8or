import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    pplication.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override init() {
        FirebaseApp.configure()
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

    override func application(_ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
          completionHandler(.noData)
          return
        }
    }

    override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
          return true
        }
        return false;
      }
}
