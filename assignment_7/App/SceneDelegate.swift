import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        if isUserLoggedIn() {
            let tabBarController = createTabBarController()
            setRootViewController(tabBarController, animated: false)
        } else {
            let loginVC = SignUpViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            setRootViewController(navigationController, animated: false)
        }
        window.makeKeyAndVisible()
    }
    private func isUserLoggedIn() -> Bool {
       
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let moviesVC = ViewController()
        moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        let moviesNavController = UINavigationController(rootViewController: moviesVC)

        let userVC = UserViewController()
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person.circle"), tag: 1)
        let userNavController = UINavigationController(rootViewController: userVC)

        tabBarController.viewControllers = [moviesNavController, userNavController]
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.tintColor = .systemPink

        return tabBarController
    }
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        window.rootViewController = vc
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }

}
