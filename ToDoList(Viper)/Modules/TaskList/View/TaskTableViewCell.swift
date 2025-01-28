//
//  TaskTableViewCell.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TaskTableViewCell"

    // MARK: - UI Comonents

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 3
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24.0
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
        let checkmarkSize = CGSize(width: 30, height: 30)

        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            statusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            statusImageView.widthAnchor.constraint(equalToConstant: checkmarkSize.width + 18.0),
            statusImageView.heightAnchor.constraint(equalToConstant: checkmarkSize.height + 18.0),

            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 10.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10.0),
            dateLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 10.0),
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
        statusImageView.tintColor = .gray
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
            statusImageView.image = UIImage(systemName: "checkmark")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            statusImageView.layer.borderColor = UIColor.yellow.cgColor
            titleLabel.textColor = .secondaryLabel
            descriptionLabel.textColor = .secondaryLabel
            guard let text = titleLabel.text else { return }
            titleLabel.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue, // Добавляем зачёркивание
                    .strikethroughColor: UIColor.secondaryLabel
                ]
            )
        } else {
            statusImageView.image = nil
            statusImageView.layer.borderColor = UIColor.gray.cgColor
            titleLabel.textColor = .label
            descriptionLabel.textColor = .label
            guard let text = titleLabel.text else { return }
            titleLabel.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: 0
                ]
            )
        }
    }
}
