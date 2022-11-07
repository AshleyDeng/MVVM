import UIKit

enum UserViewControllerState {
    case loading
    case error
    case success
}

final class UserViewController: UIViewController {
    private let userViewModel: UserViewModel
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        table.dataSource = self
        return table
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(viewModel: UserViewModel) {
        self.userViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        title = "Users"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userViewModel.loadUser()
    }
}

private extension UserViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    @objc func refresh() {
        userViewModel.loadUser()
    }
}

extension UserViewController: UserViewModelDelegate {
    func reloadData(state: UserViewControllerState) {
        switch state {
        case .loading:
            refreshControl.beginRefreshing()
        case .error:
            refreshControl.endRefreshing()
        case .success:
            refreshControl.endRefreshing()
            tableView.reloadData()
        }
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        cell.config(with: userViewModel.users[indexPath.row])
        return cell
    }
}
