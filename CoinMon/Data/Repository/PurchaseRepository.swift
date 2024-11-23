import Moya
import RxMoya
import RxSwift

class PurchaseRepository: PurchaseRepositoryInterface {
    private let provider: MoyaProvider<PurchaseService>
    
    init() {
        provider = MoyaProvider<PurchaseService>(requestClosure: MoyaProviderUtils.requestClosure, session: Session(interceptor: MoyaRequestInterceptor()))
    }
    
    func registerPurchaseReceipt(receiptData: String) -> Observable<String> {
        return provider.rx.request(.registerReceipt(receiptData: receiptData))
            .filterSuccessfulStatusCodes()
            .map(PurchaseReceiptDTO.self)
            .map{ PurchaseReceiptDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    func fetchSubscriptionStatus() -> Observable<UserSubscriptionStatus> {
        return provider.rx.request(.getSubscriptionStatus)
            .filterSuccessfulStatusCodes()
            .map(SubscriptionStatusResponseDTO.self)
            .map{ SubscriptionStatusResponseDTO.toSubscriptionStatus(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
