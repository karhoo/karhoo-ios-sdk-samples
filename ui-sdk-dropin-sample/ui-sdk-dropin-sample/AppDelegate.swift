
import KarhooUISDK
import KarhooSDK
import Braintree
import Adyen

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let urlScheme = "com.karhoo.samples.uisdk.dropin.ui-sdk-dropin-sample.Payments"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KarhooUI.set(configuration: KarhooConfig())
        BTAppSwitch.setReturnURLScheme(urlScheme)

        window = UIWindow()
        let mainView = ViewController()
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        let adyenThreeDSecureUtils = AdyenThreeDSecureUtils()
        if url.scheme?.localizedCaseInsensitiveCompare(adyenThreeDSecureUtils.current3DSReturnUrlScheme) == .orderedSame {
            return RedirectComponent.applicationDidOpen(from: url)
        }
        return false
    }


}

