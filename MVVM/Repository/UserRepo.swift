import Foundation

protocol UserServices {
    typealias LoadCompletion = (Result<[User], Error>) -> Void
    func loadUsers(completion: @escaping LoadCompletion)
}

final class UserServiceRemoteImpl: UserServices {
    func loadUsers(completion: @escaping LoadCompletion) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            let result: Result<[User], Error> = ResponseHandler.handle(data, response, error)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
}
