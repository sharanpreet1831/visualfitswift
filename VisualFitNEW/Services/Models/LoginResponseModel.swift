struct LoginResponse: Decodable {
    let success: Bool
    let token: String?
    let message: String
}
