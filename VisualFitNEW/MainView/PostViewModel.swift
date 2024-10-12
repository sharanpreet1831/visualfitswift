import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [PostResponseModel] = []
    
    func fetchPosts() {
        guard let url = URL(string: "http://localhost:4000/api/v1/post/getPosts") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GetPostResponseModel.self, from: data)
                DispatchQueue.main.async {
                    self.posts = decodedResponse.posts
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

