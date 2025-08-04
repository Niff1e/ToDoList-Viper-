//
//  TaskEditorViewController.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 27.01.25.
//

import UIKit

final class TaskEditorViewController: UIViewController, TaskEditorViewProtocol {

    // MARK: - UIComponents

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .taskEditorTitle
        textView.textColor = .mainWhite
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()

    private let titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название задачи"
        label.font = .taskEditorTitle
        label.textColor = .mainWhite
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .taskEditorDescription
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = .mainWhite
        return textView
    }()

    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Описание задачи"
        label.font = .taskEditorDescription
        label.textColor = .mainWhite
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .taskEditorDate
        label.textColor = .mainWhite05
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
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Tap Handlers

    @objc private func doneButtonTapped() {
        guard let title = titleTextView.text, let description = descriptionTextView.text else { return }
        if let task = task {
            presenter?.updateTask(withId: task.id, newTitle: title, newDescription: description)
        } else {
            presenter?.saveTask(title: title, description: description)
        }
    }

    // MARK: - Subviews

    private func setupPositionOfSubviews() {
        view.addSubview(titleTextView)
        view.addSubview(descriptionTextView)
        view.addSubview(dateLabel)
        view.addSubview(titlePlaceholderLabel)
        view.addSubview(descriptionPlaceholderLabel)
        titleTextView.delegate = self
        descriptionTextView.delegate = self

        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),

            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20.0),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),

            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20.0),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),

            titlePlaceholderLabel.topAnchor.constraint(equalTo: titleTextView.topAnchor, constant: 8),
            titlePlaceholderLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor, constant: 5),
            titlePlaceholderLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),

            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            descriptionPlaceholderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor)
        ])
    }

    private func updateUI(with task: TaskEntity?) {
        if let task = task {
            titleTextView.text = task.title
            descriptionTextView.text = task.description
            dateLabel.text = DateFormatter.localizedString(from: task.dueDate, dateStyle: .short, timeStyle: .none)
        } else {
            dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        }
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Text View Delegate

extension TaskEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titlePlaceholderLabel.isHidden = !textView.text.isEmpty
        } else if textView == descriptionTextView {
            descriptionPlaceholderLabel.isHidden = !textView.text.isEmpty
        }
    }
}
