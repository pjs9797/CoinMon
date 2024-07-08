struct SignupTranslator {
    static func toResultCode(dto: SignupDTO) -> String {
        return dto.resultCode
    }
}
