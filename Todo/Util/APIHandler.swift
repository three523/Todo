//
//  APIHandler.swift
//  Todo
//
//  Created by 김도현 on 2023/08/31.
//

import Foundation

enum APIError: Error {
    
    case url
    case decode(DecodingError)
    case transport(Error)
    case cancel
    case notConnectedToInternet
    case server(Int)
    case data
    case other(Error)
    
    var message: String {
        switch self {
        case .url:
            return "Url이 존재하지 않습니다"
        case .decode(let error):
            return error.localizedDescription
        case .transport(let error):
            return error.localizedDescription
        case .cancel:
            return URLError(.cancelled).localizedDescription
        case .notConnectedToInternet:
            return URLError(.notConnectedToInternet).localizedDescription
        case .server(let statusCode):
            return "HTTP StatusCode: \(statusCode)"
        case .data:
            return "Data의 값이 존재하지 않습니다"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

class APIHandler {
    let sesstion: URLSession = URLSession.shared
    var task: URLSessionDataTask?

    func getJson<T: Decodable>(type: T.Type, stringUrl: String, completed: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: stringUrl) else {
            completed(.failure(.url))
            return
        }
        
        task?.cancel()
        
        task = sesstion.dataTask(with: url) { data, response, error in
            if let error {
                let nsError = error as NSError
                if nsError.code == NSURLErrorCancelled {
                    completed(.failure(.cancel))
                } else if nsError.code == NSURLErrorNotConnectedToInternet || nsError.code == NSURLErrorTimedOut {
                    completed(.failure(.notConnectedToInternet))
                } else {
                    completed(.failure(.transport(error)))
                }
            } else {
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    
                    guard (200...299).contains(statusCode) else {
                        completed(.failure(.server(statusCode)))
                        return
                    }
                    guard let data else {
                        completed(.failure(.data))
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let decodeData = try decoder.decode(type, from: data)
                        completed(.success(decodeData))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        completed(.failure(.decode(DecodingError.dataCorrupted(context))))
                    } catch let DecodingError.valueNotFound(value, context) {
                        completed(.failure(.decode(DecodingError.valueNotFound(value, context))))
                    } catch let DecodingError.keyNotFound(key, context) {
                        completed(.failure(.decode(DecodingError.keyNotFound(key, context))))
                    } catch let DecodingError.typeMismatch(type, context)  {
                        completed(.failure(.decode(DecodingError.typeMismatch(type, context))))
                    } catch let error {
                        completed(.failure(.other(error)))
                    }
                }
            }
        }
        
        task?.resume()
    }
    
    func getImage(stringUrl: String, completed: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: stringUrl) else {
            completed(.failure(.url))
            return
        }
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                let nsError = error as NSError
                if nsError.code == NSURLErrorCancelled {
                    completed(.failure(.cancel))
                } else if nsError.code == NSURLErrorNotConnectedToInternet {
                    completed(.failure(.notConnectedToInternet))
                } else {
                    completed(.failure(.transport(error)))
                }
            } else {
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    
                    guard (200...299).contains(statusCode) else {
                        completed(.failure(.server(statusCode)))
                        return
                    }
                    guard let data else {
                        completed(.failure(.data))
                        return
                    }
                    completed(.success(data))
                }
            }
        }
        
        task?.resume()
    }
}
