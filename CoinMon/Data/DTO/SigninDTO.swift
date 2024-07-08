struct SigninDTO: Codable {
    let resultCode: String
    let resultMessage: String
}

struct SigninResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: SigninDataDTO?
}

struct SigninDataDTO: Codable {
    let imgIndex: String
    let phoneNumber: String
    let nickname: String
    let userType: String?
    let accessToken: String
    let email: String
    let refreshToken: String
}
