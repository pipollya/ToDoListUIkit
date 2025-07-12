import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    private var todos: [ToDoItem] = []

    private let todosKey = "todos_storage_key"

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        loadTodos()

        view.addSubview(tableView)
        constrainTableView()
        configureTableView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(openAlert)
        )
    }

    
    private func constrainTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        tableView.allowsSelection = false
    }

  
    @objc private func openAlert() {
        let alert = UIAlertController(title: "Create todo", message: nil, preferredStyle: .alert)
        alert.addTextField()

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textName = alert.textFields?.first?.text, !textName.isEmpty {
                self.addTodo(name: textName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func addTodo(name: String) {
        todos.append(ToDoItem(name: name))
        saveTodos()
        tableView.reloadData()
    }

    private func saveTodos() {
        if let data = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(data, forKey: todosKey)
        }
    }

    private func loadTodos() {
        if
            let data = UserDefaults.standard.data(forKey: todosKey),
            let saved = try? JSONDecoder().decode([ToDoItem].self, from: data)
        {
            todos = saved
        } else {
            todos = [ToDoItem(name: "test item")]
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todoItem = todos[indexPath.row]

        cell.textLabel?.text = todoItem.name
        cell.accessoryType = todoItem.isCompleted ? .checkmark : .none

        return cell
    }
}


