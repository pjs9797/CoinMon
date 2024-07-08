struct SigninTranslator {
    static func toResultCode(dto: SigninDTO) -> String {
        return dto.resultCode
    }
    
    static func toAuthTokens(dto: SigninResponseDTO) -> AuthTokens? {
        if let data = dto.data {
            return AuthTokens(resultCode: dto.resultCode, accessToken: data.accessToken, refreshToken: data.refreshToken)
        } else {
            return nil
        }
    }
}
