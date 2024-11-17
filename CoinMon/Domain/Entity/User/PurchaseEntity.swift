struct UserSubscriptionStatus: Equatable {
    let user: String
    let productId: String?
    let purchaseDate: String?
    let expiresDate: String?
    let isTrialPeriod: String?
    let autoRenewStatus: String?
    let status: SubscriptionStatus
    let useTrialYN: String
}
