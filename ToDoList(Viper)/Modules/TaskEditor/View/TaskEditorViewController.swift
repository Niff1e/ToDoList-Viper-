//
//  TaskEditorViewController.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import UIKit

final class TaskEditorViewController: UIViewController, TaskEditorViewProtocol {

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
    }

    // MARK: - Tap Handlers

    @objc private func doneButtonTapped() {
        guard let title = titleTextField.text, let description = descriptionTextField.text else { return }
        if let task = task {
            presenter?.updateTask(withId: task.id, newTitle: title, newDescription: description)
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

    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
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
