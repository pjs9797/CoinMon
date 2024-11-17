import RxSwift

protocol PurchaseRepositoryInterface {
    func registerPurchaseReceipt(receiptData: String) -> Observable<String>
    func fetchSubscriptionStatus() -> Observable<UserSubscriptionStatus>
}
