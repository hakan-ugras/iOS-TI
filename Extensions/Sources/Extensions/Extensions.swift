import Foundation
import UIKit

public extension UIApplication {
    
    var appWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
    
    func topViewController(
        controller: UIViewController? = UIApplication.shared.appWindow?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            
            if let selected = tabController.selectedViewController as? UINavigationController {
                return topViewController(controller: selected.visibleViewController)
            }
            
            return topViewController(controller: tabController.selectedViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func routeToSettings(completionHandler: ((Bool) -> Void)? = nil) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                open(settingsUrl, options: [:], completionHandler: nil)
            }
            if #available(iOS 10.0, *) {
                open(settingsUrl, options: [:], completionHandler: completionHandler)
            }
        }
    }
    
    class func getViewController<T: UIViewController>(inScene named: String? = nil,
                                                      rootViewController: Bool = true) -> T {
        let controllerName = String(describing: T.self)
        let storyboardName = named ?? substringStoryboardName(withViewControllerName: controllerName)
        if rootViewController,
           let viewController = UIStoryboard(
            name: String(storyboardName), bundle: nil
           ).instantiateInitialViewController() as? T {
            return viewController
        } else if let viewController = UIStoryboard(
            name: String(storyboardName), bundle: nil
        ).instantiateViewController(withIdentifier: controllerName) as? T {
            return viewController
        } else {
            fatalError("InstantiateInitialViewController not found")
        }
    }
    
    private class func substringStoryboardName(withViewControllerName controllerName: String) -> String {
        let viewControllerName = controllerName
        if let range = viewControllerName.range(of: "ViewController") {
            return String( viewControllerName[..<range.lowerBound] )
        } else {
            return controllerName
        }
    }
    
}

public extension String {
    
    func formatDate(with format: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}

