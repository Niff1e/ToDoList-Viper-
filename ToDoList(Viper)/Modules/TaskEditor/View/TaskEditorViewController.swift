//
//  TaskEditorViewController.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import UIKit

class TaskEditorViewController: UIViewController, TaskEditorViewProtocol {

    // MARK: - UIComponents

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Название задачи"
        textField.font = UIFont.systemFont(ofSize: 45.0, weight: .medium)
        textField.textColor = .label
        return textField
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Описание задачи"
        textField.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        textField.textColor = .label
        return textField
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    // MARK: - Properties

    var presenter: TaskEditorPresenterProtocol?
    private var task: TaskEntity?

    var onTaskListUpdate: ((Result<Void, Error>) -> Void)?

    // MARK: - Init

    init(task: TaskEntity? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPositionOfSubviews()
        updateUI(with: task)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let title = titleTextField.text, let description = descriptionTextField.text else { return }
        if let task = task {
            if task.title != titleTextField.text || task.description != descriptionTextField.text {
                presenter?.update(task: task, withTitle: title, description: description)
            }
        } else {
            presenter?.saveTask(title: title, description: description)
        }
    }

    // MARK: - Subviews

    private func setupPositionOfSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(dateLabel)
        titleTextField.delegate = self
        descriptionTextField.delegate = self

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20.0),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),

            descriptionTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20.0),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ])
    }

    private func updateUI(with task: TaskEntity?) {
        if let task = task {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            dateLabel.text = DateFormatter.localizedString(from: task.dueDate, dateStyle: .short, timeStyle: .none)
        } else {
            dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        }
    }
}

// MARK: - Text Field Delegate

extension TaskEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
