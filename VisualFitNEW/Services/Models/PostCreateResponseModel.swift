
import Foundation

// Define the Post model based on the API response structure
struct Post: Codable {
    let userId: String
    let title: String
    let image: String
    let likes: [String] // Assuming likes are strings, adjust if they're different
    let comments: [String] // Assuming comments are strings, adjust if they're different
    let id: String // Renamed to `id` for Swift convention
    let createdAt: String // You might want to convert this to Date type
    let updatedAt: String // You might want to convert this to Date type
    let v: Int // Renamed __v to v for Swift convention

    enum CodingKeys: String, CodingKey {
        case userId
        case title
        case image
        case likes
        case comments
        case id = "_id" // Map "_id" from JSON to `id`
        case createdAt
        case updatedAt
        case v = "__v" // Map __v from JSON to `v`
    }
}

// Define the response model for the API
struct PostResponse: Codable {
    let success: Bool
    let post: Post
}
