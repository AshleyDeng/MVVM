import Foundation

protocol UserViewModelDelegate: AnyObject {
    func reloadData(state: UserViewControllerState)
}

protocol UserViewModel {
    var users: [User] { get }
    
    func loadUser()
}

final class UserViewModelImpl: UserViewModel {
    private let service: UserServices
    
    private(set) var users: [User]
    
    weak var delegate: UserViewModelDelegate?
    
    init(service: UserServices = UserServiceRemoteImpl()) {
        self.service = service
        self.users = []
    }
    
    func loadUser() {
        delegate?.reloadData(state: .loading)
        service.loadUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.delegate?.reloadData(state: .success)
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.reloadData(state: .error)
            }
        }
    }
}
