import Flutter
import UIKit
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // In AppDelegate.application method
      WorkmanagerPlugin.registerTask(withIdentifier: "getallanimals-task-identifier")

      // Register a periodic task in iOS 13+
      WorkmanagerPlugin.registerTask(withIdentifier: "be.tramckrijte.workmanagerExample.iOSBackgroundAppRefresh")
      
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
