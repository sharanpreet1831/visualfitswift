struct LoginResponse: Codable {
    let success: Bool
    let token: String
    let message: String
    let user: UserLoginResponse?
    
    struct UserLoginResponse: Codable {
        let id: String // Corresponds to "_id"
        let name: String
        let username: String
        let email: String
        let password: String? // Optional since it's null
        let avatar: String
        let bio: String
        let posts: [String] // Array of post IDs
        let isPersonalDetailsSet: Bool
        let isGoalSet: Bool
        let isFitnessGoalSet: Bool
        let personalDetails: String
        let setGoal: String
        let fitnessGoal: String
        let createdAt: String
        let updatedAt: String
        let v: Int // Corresponds to "__v"
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name, username, email, password, avatar, bio, posts,
                 isPersonalDetailsSet, isGoalSet, isFitnessGoalSet,
                 personalDetails, setGoal, fitnessGoal, createdAt, updatedAt
            case v = "__v"
        }
    }
}
