struct UserTranslator {
    static func toResultCode(dto: UserDTO) -> String {
        return dto.resultCode
    }
    
    static func toUserData(dto: UserResponseDTO) -> UserData {
        let data = dto.data
        return UserData(imgIndex: data.imgIndex, phoneNumber: data.phoneNumber, nickname: data.nickname, userType: data.userType, email: data.email)
    }
}
