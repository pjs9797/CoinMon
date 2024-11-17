import RxSwift

class PurchaseUseCase {
    private let repository: PurchaseRepositoryInterface

    init(repository: PurchaseRepositoryInterface) {
        self.repository = repository
    }
    
    func registerPurchaseReceipt(receiptData: String) -> Observable<String> {
        return repository.registerPurchaseReceipt(receiptData: receiptData)
    }
    
    func fetchSubscriptionStatus() -> Observable<UserSubscriptionStatus> {
        return repository.fetchSubscriptionStatus()
    }
}
