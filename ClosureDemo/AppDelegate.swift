import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController(rootViewController: ViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.viewControllers.first?.title = "Closure Demo"
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
