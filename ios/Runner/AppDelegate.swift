import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        WorkmanagerPlugin.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(
        _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            if url.scheme == "taskmanager", url.host == "counterAction" {
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
                    let hoursValue = queryItems.first(where: { $0.name == "hours" })?.value,
                    let selectedNumber = Int(hoursValue) {
                    UserDefaults.standard.set(selectedNumber, forKey: "selectedNumber")
                    NotificationCenter.default.post(name: Notification.Name("widgetButtonTapped"), object: nil)
                    return true
                }
            }
            return false
    }
}
