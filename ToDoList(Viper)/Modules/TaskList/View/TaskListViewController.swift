//
//  TaskListViewController.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 23.01.25.
//

import UIKit

final class TaskListViewController: UIViewController, TaskListViewProtocol {

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        return tableView
    }()

    private let searchController = UISearchController(searchResultsController: nil)


    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .footerView
        return view
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.imageView?.tintColor = .accent
        button.setTitleColor(.accent, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Задач"
        label.textColor = .mainWhite
        label.font = .taskListTaskCount
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .systemMaterial)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()

    private var menuView: UIView = {
        let menuView = UIView()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.backgroundColor = .menuView
        menuView.layer.cornerRadius = 12
        menuView.alpha = 0
        return menuView
    }()

    // MARK: - Propeties

    private var selectedTaskIndex: Int?

    var presenter: TaskListPresenterProtocol?

    private var tasks: [TaskEntity] = []

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        setupSearchController()
        setupUI()
        presenter?.viewDidLoad()
    }

    // MARK: - Setups of UI Components

    private func setupSearchController() {
        navigationItem.searchController = searchController

        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal

        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }

    private func setupUI() {
        setupFooterView()
        setupTableView()
        setupBlurView()
        setupTaskCountLabel()
        setupAddButton()
        setupMenuView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }

    private func setupFooterView() {
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }

    private func setupBlurView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurView.addGestureRecognizer(tapGesture)
        view.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAddButton() {

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        footerView.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: taskCountLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            addButton.widthAnchor.constraint(equalToConstant: 28.0),
            addButton.heightAnchor.constraint(equalToConstant: 28.0)
        ])
    }

    private func setupTaskCountLabel() {

        footerView.addSubview(taskCountLabel)

        NSLayoutConstraint.activate([
            taskCountLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20.0),
            taskCountLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor)
        ])
    }

    private func setupMenuView() {

        let buttonTitles = ["Редактировать", "Поделиться", "Удалить"]
        let buttonIcons = ["square.and.pencil", "square.and.arrow.up", "trash"]
        let buttonColors: [UIColor] = [.mainBlack, .mainBlack, .mainRed]

        // Высота кнопки и сепаратора
        let buttonHeight: CGFloat = 50
        let separatorHeight: CGFloat = 1 / UIScreen.main.scale

        for (index, title) in buttonTitles.enumerated() {
            // Создание кнопки
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(buttonColors[index], for: .normal)
            button.titleLabel?.font = .taskListMenuView
            button.contentHorizontalAlignment = .left
            button.tag = index

            // Добавляем действие для кнопки
            button.addTarget(self, action: #selector(menuOptionTapped(_:)), for: .touchUpInside)

            // Добавление иконки справа
            let icon = UIImage(systemName: buttonIcons[index])
            let iconView = UIImageView(image: icon)
            iconView.tintColor = buttonColors[index]
            iconView.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(iconView)

            // Размещение иконки
            NSLayoutConstraint.activate([
                iconView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
                iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])

            // Добавляем кнопку в menuView
            menuView.addSubview(button)

            // Настраиваем размеры кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -8),
                button.heightAnchor.constraint(equalToConstant: buttonHeight),
                button.topAnchor.constraint(equalTo: menuView.topAnchor, constant: CGFloat(index) * (buttonHeight + separatorHeight))
            ])

            // Добавление сепаратора, если это не последняя кнопка
            if index < buttonTitles.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .lightGray
                separator.translatesAutoresizingMaskIntoConstraints = false
                menuView.addSubview(separator)

                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
                    separator.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
                    separator.heightAnchor.constraint(equalToConstant: separatorHeight),
                    separator.topAnchor.constraint(equalTo: button.bottomAnchor)
                ])
            }
        }

        // Настройка размеров и внешнего вида menuView
        let totalHeight = CGFloat(buttonTitles.count) * buttonHeight + CGFloat(buttonTitles.count - 1) * separatorHeight
        menuView.layer.cornerRadius = 12
        menuView.clipsToBounds = true

        view.addSubview(menuView)

        // Установка размеров menuView
        NSLayoutConstraint.activate([
            menuView.widthAnchor.constraint(equalToConstant: 250),
            menuView.heightAnchor.constraint(equalToConstant: totalHeight),
            menuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Taps Handlers

    @objc private func addButtonTapped() {
        presenter?.addTask()
    }

    @objc private func dismissMenu() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 0
            self.menuView.alpha = 0
        }
    }

    @objc private func menuOptionTapped(_ sender: UIButton) {
        guard let selectedIndex = selectedTaskIndex else { return }
        switch sender.tag {
        case 0:
            let task = tasks[selectedIndex]
            presenter?.editTask(task)
        case 1:
            print("Shared")
        case 2:
            let task = tasks[selectedIndex]
            presenter?.deleteTask(withId: task.id)
        default:
            break
        }
        dismissMenu()
    }

    // MARK: -  Helper Functions for Clicking on a Cell

    private func blurExceptCell(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedTaskIndex = indexPath.row

        // Конверсия координат выбранной ячейки в координатную систему view
        let cellFrame = tableView.convert(cell.frame, to: view)

        // Создание маски для blurView
        let path = UIBezierPath(rect: view.bounds)
        let cellPath = UIBezierPath(roundedRect: cellFrame, cornerRadius: 8)
        path.append(cellPath)
        path.usesEvenOddFillRule = true

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd

        blurView.layer.mask = maskLayer
        blurView.clipsToBounds = true

        // Отобразить blurView
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
        }
    }

    private func showMenu(below cell: UITableViewCell?) {
        guard let cell = cell else { return }

        // Получаем позицию ячейки относительно всего окна
        let cellFrameInView = cell.convert(cell.bounds, to: view)

        // Вычисляем дочкступное место снизу
        let spaceBelow = view.frame.height - cellFrameInView.maxY

        // Определяем позицию меню
        let isEnoughSpaceBelow = spaceBelow >= menuView.frame.height + 25.0
        let menuPositionY: CGFloat

        if isEnoughSpaceBelow {
            // Если места снизу достаточно, отображаем меню под ячейкой
            menuPositionY = cellFrameInView.maxY + menuView.frame.height / 1.8
        } else {
            // Если места снизу недостаточно, отображаем меню над ячейкой
            menuPositionY = cellFrameInView.minY - menuView.frame.height / 1.8
        }

        // Позиционируем меню
        menuView.center = CGPoint(x: view.center.x, y: menuPositionY)

        // Показываем меню
        UIView.animate(withDuration: 0.3) {
            self.menuView.alpha = 1
        }
    }

    // MARK: - UI-Updating Functions

    func updateTaskList(_ tasks: [TaskEntity]) {
        DispatchQueue.main.async {
            self.tasks = tasks
            self.taskCountLabel.text = "\(self.tasks.count) Задач"
            self.tableView.reloadData()
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

// MARK: - TableView Delegate and Data Source Methods

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        blurExceptCell(at: indexPath)
        showMenu(below: tableView.cellForRow(at: indexPath))
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markAsCompletedAction = UIContextualAction(style: .normal, title: "Выполнить") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            let taskId = self.tasks[indexPath.row].id
            self.presenter?.toggleTaskCompletion(forId: taskId)
            completion(true)
        }
        markAsCompletedAction.backgroundColor = .systemYellow

        return UISwipeActionsConfiguration(actions: [markAsCompletedAction])
    }
}

// MARK: - Search Bar Delegate and Search Results Updationg Methods

extension TaskListViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.cancelSearch()
    }

    func updateSearchResults(for searchController: UISearchController) {
        presenter?.searchTasks(with: searchController.searchBar.text ?? "")
    }
}

