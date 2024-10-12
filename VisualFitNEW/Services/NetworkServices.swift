import Foundation
import SwiftUI

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingFailed
}

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func postData<T: Decodable>(to urlString: String, with jsonData: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        let authToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }.resume()
    }
    
    func fetchData<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }.resume()
    }
    
    func postImageData(to urlString: String, image: UIImage, title: String, completion: @escaping (Result<PostResponse, NetworkError>) -> Void) {
           guard let url = URL(string: urlString) else {
               completion(.failure(.badURL))
               return
           }
           
           guard let authToken = UserDefaults.standard.string(forKey: "accessToken") else {
               completion(.failure(.requestFailed))
               return
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
           
           // Create boundary
           let boundary = UUID().uuidString
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

           // Create data
           var body = Data()
           
           // Title
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(title)\r\n".data(using: .utf8)!)
           
           // Image
           if let imageData = image.jpegData(compressionQuality: 0.8) {
               body.append("--\(boundary)\r\n".data(using: .utf8)!)
               body.append("Content-Disposition: form-data; name=\"postPicture\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
               body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
               body.append(imageData)
               body.append("\r\n".data(using: .utf8)!)
           }
           
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
           
           request.httpBody = body
           
           // Perform request
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let _ = error {
                   completion(.failure(.requestFailed))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(.requestFailed))
                   return
               }
               
               do {
                   print(data) // Debugging print statement
                   let decodedResponse = try JSONDecoder.customDateDecoder.decode(PostResponse.self, from: data)
                   DispatchQueue.main.async {
                       completion(.success(decodedResponse))
                   }
               } catch {
                   print("Decoding error: \(error)") // Print error for debugging
                   DispatchQueue.main.async {
                       completion(.failure(.decodingFailed))
                   }
               }
           }.resume()
       }
}

extension JSONDecoder {
    static var customDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
