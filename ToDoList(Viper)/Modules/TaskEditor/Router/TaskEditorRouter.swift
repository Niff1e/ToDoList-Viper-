//
//  TaskEditorRouter.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import Foundation
import UIKit

final class TaskEditorRouter: TaskEditorRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
