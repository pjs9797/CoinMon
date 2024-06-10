struct SigninDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: SigninDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}
