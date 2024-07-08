struct UserDTO: Codable {
    let resultCode: String
    let resultMessage: String
}

struct UserResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: UserDataDTO
}

struct UserDataDTO: Codable {
    let imgIndex: String
    let phoneNumber: String
    let nickname: String
    let userType: String?
    let email: String
}
