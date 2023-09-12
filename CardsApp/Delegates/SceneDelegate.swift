import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
  
    let container: Container = {
        let container = Container()
        container.register(Storage.self) { _ in CoreData() }.inObjectScope(.container)
        container.register(NumberProtocol.self) { _ in Number(number: 10) }
        container.register(LoggerProtocol.self) { (resolver: Resolver, someString: String, titleString: String) in
            Logger(number: resolver.resolve(NumberProtocol.self)!, someString: someString, titleScreen: titleString) }
            return container
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let menuViewController = MenuViewController(container: container)
        let navigationController = UINavigationController(rootViewController: menuViewController)
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
