import SwiftUI
import Foundation

struct FetchCommentResponse: Codable {
    let success: Bool
    let comments: [FetchComment]
}

struct FetchComment: Identifiable, Codable {
    let id: String
    let postId: String
    let userId: UserId
    let text: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"  // Maps the JSON _id to the Swift id
        case postId, userId, text, createdAt, updatedAt
    }
}

struct UserId: Codable {
    let id: String
    let username: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case avatar
    }
}


class CommentViewModel: ObservableObject {
    @Published var comments: [FetchComment] = []

    func fetchComments(for postId: String) {
        guard !postId.isEmpty else {
            print("Post ID is empty")
            return
        }


        guard let url = URL(string: "http://localhost:4000/api/v1/post/allComments/\(postId)") else {
            print("Invalid URL")
            return
        }

       

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // Set content type
        

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching comments: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Print the raw response data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(FetchCommentResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.comments = decodedResponse.comments // Assign comments to your published property
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                // More detailed logging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                }
            }
        }.resume()
    }


    func addComment(to postId: String, comment: String) {
        guard let url = URL(string: "http://localhost:4000/api/v1/post/comment") else {
                    print("Invalid URL")
                    return
                }

        let commentData: [String: Any] = ["postId": postId,"text": comment]

                guard let jsonData = try? JSONSerialization.data(withJSONObject: commentData, options: []) else {
                    print("Failed to encode comment data")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error adding comment: \(error)")
                        return
                    }

                    DispatchQueue.main.async {
                        self.fetchComments(for: postId)
                    }
                }.resume()
    }
}

