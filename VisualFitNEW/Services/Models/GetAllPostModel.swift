import Foundation

// Response structure for the API
struct GetPostResponseModel: Codable {
    let success: Bool
    let posts: [PostResponseModel]
}

// Structure for a Like
struct Like: Codable, Identifiable {
    var id: String { // Use _id as the unique identifier
        return _id
    }
    let _id: String
    let postId: String
    let userId: String
    let creationTime: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
}

// Structure for a Comment
struct Comment: Identifiable, Codable {
    var id: String { _id }
    let _id: String
    let postId: String
    let userId: String
    let text: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case _id
        case postId
        case userId
        case text
        case createdAt
        case updatedAt
    }
}

// Structure for a Post
struct PostResponseModel: Codable, Identifiable {
    let id: String // This corresponds to "_id" in JSON
    let userId: GetUserPost? 
    let title: String
    let image: String
    let likes: [Like]
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case title
        case image
        case likes
        case comments
    }
}

// Structure for User associated with a Post
struct GetUserPost: Codable {
    let id: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
    }
}
