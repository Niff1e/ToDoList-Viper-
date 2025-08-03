//
//  SceneDelegate.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Essential app components are missing.")
        }

        let coreDataContainer = appDelegate.persistentContainer
        let rootController = TaskListBuilder.build(coreDataContainer: coreDataContainer)

        let window = UIWindow(windowScene: windowScene)

        let navigationVC = UINavigationController(rootViewController: rootController)

        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.navigationBar.tintColor = .yellow
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 41.0),
        ]
        
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
        self.window = window
    }
}

