struct UserDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: UserDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}

struct UserResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: UserDataDTO
    
    static func toUserData(dto: UserResponseDTO) -> UserData {
        let data = dto.data
        return UserData(imgIndex: data.imgIndex, phoneNumber: data.phoneNumber, nickname: data.nickname, userType: data.userType, email: data.email)
    }
}

struct UserDataDTO: Codable {
    let imgIndex: String
    let phoneNumber: String
    let nickname: String
    let userType: String?
    let email: String
}
