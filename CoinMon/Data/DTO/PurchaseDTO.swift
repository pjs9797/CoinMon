struct PurchaseReceiptDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: PurchaseReceiptDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}

struct SubscriptionStatusResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: SubscriptionStatusDTO
    }
    
    static func toSubscriptionStatus(dto: SubscriptionStatusResponseDTO) -> UserSubscriptionStatus {
        let info = dto.data.info
        let status: SubscriptionStatus
        switch info.status {
        case "normal":
            status = .normal
        case "trial":
            status = .trial
        case "subscription":
            status = .subscription
        default:
            status = .normal
        }
        
        return UserSubscriptionStatus(user: info.user, productId: info.productId, purchaseDate: info.purchaseDate, expiresDate: info.expiresDate, isTrialPeriod: info.isTrialPeriod, autoRenewStatus: info.autoRenewStatus, status: status, useTrialYN: info.useTrialYN)
    }
}

struct SubscriptionStatusDTO: Codable {
    let user: String
    let productId: String?
    let purchaseDate: String?
    let expiresDate: String?
    let isTrialPeriod: String?
    let autoRenewStatus: String?
    let status: String
    let useTrialYN: String
}
