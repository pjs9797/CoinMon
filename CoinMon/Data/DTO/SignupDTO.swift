struct SignupDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: SignupDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}
