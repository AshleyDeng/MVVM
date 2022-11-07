import Foundation

struct ResponseHandler {
    static func handle<Model: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Model, Error> {
        if let error = error {
            return .failure(error)
        }
        
        guard let response = response as? HTTPURLResponse else {
            return .failure(NetworkResponseError.httpURLResponseCastFailed)
        }

        switch handleResponseStatus(response) {
        case .success:
            guard let data = data else {
                return .failure(NetworkResponseError.noData)
            }
            
            do {
                let result = try JSONDecoder().decode(Model.self, from: data)
                print(result)
                return .success(result)
            } catch(let error) {
                print(error)
                return .failure(NetworkResponseError.unableToDecode)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

private extension ResponseHandler {
    static func handleResponseStatus(_ response: HTTPURLResponse) -> Result<Void, Error> {
        switch response.statusCode {
            case 200...299: return .success(())
            case 401...500: return .failure(NetworkResponseError.authenticationError)
            case 501...599: return .failure(NetworkResponseError.badRequest)
            case 600: return .failure(NetworkResponseError.outdated)
            default: return .failure(NetworkResponseError.failed)
        }
    }
}
