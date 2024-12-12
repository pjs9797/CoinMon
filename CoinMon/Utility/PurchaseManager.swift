import StoreKit
import RxSwift

enum PurchaseEvent {
    case purchaseFailed      // 인앱 결제 실패 시
    case verificationFailed  // 결제는 성공했으나 서버 검증 실패 시
    case verificationSuccess // 결제 및 검증 성공 시
    case loadingFinished
}

class PurchaseManager: NSObject, SKRequestDelegate {
    static let shared = PurchaseManager()
    let disposeBag = DisposeBag()
    private let productIds = ["com.hiperBollinger.premium.monthly"]
    private(set) var products: [Product] = []
    private var productsLoaded = false
    
    // 구매 상태를 알리기 위한 Subject
    let purchaseEvent = PublishSubject<PurchaseEvent>()
    
    private(set) var purchasedProductIDs = Set<String>()
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    private var transactionListener: Task<Void, Never>? = nil
    let purchaseUseCase = PurchaseUseCase(repository: PurchaseRepository())
    
    private override init() {
        super.init()
        //startObservingTransactionUpdates()
    }
    
    // 제품 로드 메서드
    func loadProducts() async throws {
        guard !self.productsLoaded else {
            print("Products are already loaded.")
            return
        }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
        //print("Products loaded: \(products)")
    }
    
    // 구매 메서드
    func purchase(_ product: Product) async throws {
        print("Attempting to purchase: \(product)")
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            print("Purchase successful and verified for product ID: \(transaction.productID)")
            let purchaseDate = transaction.purchaseDate
            let expiresDate = transaction.expirationDate ?? Date()
            print("Purchase Date (KST): \(formatDateToKST(purchaseDate))")
            print("Expires Date (KST): \(formatDateToKST(expiresDate))")
            await transaction.finish()
            await self.updatePurchasedProducts()
            await verifyOrRefreshReceipt()
            
        case .success(.unverified(_, _)):
            print("Purchase successful but verification failed.")
            purchaseEvent.onNext(.verificationFailed) // 검증 실패 이벤트
            
        case .pending:
            print("Purchase is pending approval or SCA.")
            
        case .userCancelled:
            print("User cancelled the purchase.")
            purchaseEvent.onNext(.purchaseFailed) // 구매 실패 이벤트
            
        @unknown default:
            print("An unknown state occurred during purchase.")
        }
    }

    // 영수증 데이터 검증
    private func verifyOrRefreshReceipt() async {
        if let receiptData = base64Receipt {
            await verifyReceiptWithServer(receiptData: receiptData)
        } else {
            print("No receipt found. Attempting to refresh receipt...")
            await refreshReceipt()
        }
    }
    
    // 영수증 갱신 메서드
    private func refreshReceipt() async {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
        
//        await waitForReceiptRefresh()
        
        if let newReceiptData = base64Receipt {
            await verifyReceiptWithServer(receiptData: newReceiptData)
        } else {
            print("Failed to retrieve receipt data after refresh.")
        }
    }

    // 서버에 영수증 검증 요청
    private func verifyReceiptWithServer(receiptData: String) async {
        purchaseUseCase.registerPurchaseReceipt(receiptData: receiptData)
            .subscribe(onNext: { [weak self] response in
                print("Verification response from server: \(response)")
                self?.purchaseEvent.onNext(.verificationSuccess) // 검증 성공 이벤트
            }, onError: { [weak self] error in
                print("Error verifying receipt with server: \(error.localizedDescription)")
                self?.purchaseEvent.onNext(.verificationFailed) // 검증 실패 이벤트
            }, onCompleted: { [weak self] in
                // 로딩 상태 종료
                self?.purchaseEvent.onNext(.loadingFinished)
            })
            .disposed(by: disposeBag)
    }
    
    // 트랜잭션 업데이트 감시 메서드
    func startObservingTransactionUpdates() {
        print("Started observing transaction updates.")
        transactionListener = Task(priority: .background) { [weak self] in
            for await update in Transaction.updates {
                do {
                    let transaction = try self?.verifyPurchase(update)
                    await transaction?.finish()
                } catch {
                    print("Transaction verification or purchase failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 트랜잭션 검증 메서드
    func verifyPurchase<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let transaction):
            print("Transaction verified: \(transaction)")
            return transaction
        case .unverified(_, let error):
            print("Transaction verification failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // 구매된 제품 업데이트
    func updatePurchasedProducts() async {
        print("Updating purchased products...")
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("Transaction verification failed.")
                continue
            }
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                print("Product purchased: \(transaction.productID)")
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
                print("Product revoked: \(transaction.productID)")
            }
        }
    }
    
    // 영수증 데이터를 가져와서 Base64로 인코딩한 문자열을 반환
    var base64Receipt: String? {
        Bundle.main.appStoreReceiptURL
            .flatMap({ try? Data(contentsOf: $0) })
            .map { $0.base64EncodedString() }
    }
    
    // 영수증 갱신 대기 메서드
    private var receiptRefreshCompleted = false
    private func waitForReceiptRefresh() async {
        receiptRefreshCompleted = false
        while !receiptRefreshCompleted {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
        }
    }
    
    // 인앱 결제를 실행하는 메서드
    func purchaseProduction() {
        guard let product = products.first else {
            print("Product is not available.")
            return
        }
        
        Task {
            do {
                try await purchase(product)
            } catch {
                print("Purchase failed: \(error.localizedDescription)")
                purchaseEvent.onNext(.purchaseFailed) // 구매 실패 이벤트 발행
            }
        }
    }
    
    // SKRequestDelegate 메서드: 영수증 갱신 성공 시 호출
    func requestDidFinish(_ request: SKRequest) {
        print("Receipt refreshed successfully.")
        receiptRefreshCompleted = true
    }
    
    // SKRequestDelegate 메서드: 영수증 갱신 실패 시 호출
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to refresh receipt: \(error.localizedDescription)")
        receiptRefreshCompleted = true
    }
    
    // 한국 시간(KST)으로 날짜 포맷팅 함수
    private func formatDateToKST(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 표준시
        return formatter.string(from: date)
    }
}
