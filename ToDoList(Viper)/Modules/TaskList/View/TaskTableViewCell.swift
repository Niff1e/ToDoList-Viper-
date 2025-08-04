//
//  TaskTableViewCell.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TaskTableViewCell"

    // MARK: - UI Comonents

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .taskListTodoTitle
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .taskListTodoDescription
        label.numberOfLines = 3
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .taskListTodoDescription
        label.textColor = .mainWhite05
        return label
    }()

    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.contentMode = .center
        let size: CGFloat = 24.0
        imageView.layer.cornerRadius = size / 2
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPositionOfSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    private func setupPositionOfSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(dateLabel)
        self.addSubview(statusImageView)
        let checkmarkSize = CGSize(width: 24, height: 24)

        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            statusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            statusImageView.widthAnchor.constraint(equalToConstant: checkmarkSize.width),
            statusImageView.heightAnchor.constraint(equalToConstant: checkmarkSize.height),



            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10.0),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        statusImageView.image = nil
        statusImageView.tintColor = .mainGray
        statusImageView.layer.borderColor = .none
    }

    // MARK: - Configure content

    func configure(with task: TaskEntity) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = DateFormatter.localizedString(from: task.dueDate, dateStyle: .short, timeStyle: .none)
        updateStatus(task.isCompleted)
    }

    private func updateStatus(_ isCompleted: Bool) {
        if isCompleted {

            statusImageView.layer.borderColor = UIColor.accent.cgColor

            statusImageView.image = UIImage(named: "tick")
            statusImageView.tintColor = .accent

            titleLabel.textColor = .mainWhite05
            descriptionLabel.textColor = .mainWhite05
            titleLabel.strikeThrough(true)

        } else {

            statusImageView.layer.borderColor = UIColor.mainGray.cgColor

            statusImageView.image = nil

            titleLabel.textColor = .mainWhite
            descriptionLabel.textColor = .mainWhite
            titleLabel.strikeThrough(false)
        }
    }
}
