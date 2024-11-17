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
    let data: SigninDataDTO?
    
    static func toAuthTokens(dto: SigninResponseDTO) -> AuthTokens? {
        if let data = dto.data {
            return AuthTokens(resultCode: dto.resultCode, accessToken: data.accessToken, refreshToken: data.refreshToken)
        }
        else {
            return AuthTokens(resultCode: dto.resultCode, accessToken: "", refreshToken: "")
        }
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

struct AppleLoginResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataType?

    enum DataType: Codable {
        case signinData(SigninDataDTO)
        case emailData(EmailDataDTO)
        case none

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let signinData = try? container.decode(SigninDataDTO.self) {
                self = .signinData(signinData)
            } else if let emailData = try? container.decode(EmailDataDTO.self) {
                self = .emailData(emailData)
            } else {
                self = .none
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .signinData(let data):
                try container.encode(data)
            case .emailData(let data):
                try container.encode(data)
            case .none:
                break
            }
        }
    }
    
    static func toResponse(dto: AppleLoginResponseDTO) -> Any {
        switch dto.resultCode {
        case "200":
            if case .signinData(let signinData) = dto.data {
                return AuthTokens(resultCode: dto.resultCode, accessToken: signinData.accessToken, refreshToken: signinData.refreshToken)
            } else {
                return AuthTokens(resultCode: dto.resultCode, accessToken: "", refreshToken: "")
            }
        case "202":
            if case .emailData(let emailData) = dto.data {
                return (dto.resultCode, emailData.email)
            }
        default:
            return dto.resultCode
        }
        return dto.resultCode
    }
}

struct EmailDataDTO: Codable {
    let email: String
}
