struct SigninDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: SigninDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}

struct SigninResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: SigninDataDTO
    
    static func toAuthTokens(dto: SigninResponseDTO) -> AuthTokens {
        let data = dto.data
        return AuthTokens(resultCode: dto.resultCode, accessToken: data.accessToken, refreshToken: data.refreshToken)
    }
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
