import StoreKit

class PurchaseManager {

    static let shared = PurchaseManager()

    private let productIds = ["com.hiperBollinger.premium.monthly"]
    private(set) var products: [Product] = []
    private var productsLoaded = false

    private(set) var purchasedProductIDs = Set<String>()
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }

    // 트랜잭션 리스너를 위한 Task
    private var transactionListener: Task<Void, Never>? = nil

    private init() {
        // 앱 시작과 동시에 트랜잭션 리스너 시작
        startObservingTransactionUpdates()
    }

    // 제품 로드 메서드
    func loadProducts() async throws {
        guard !self.productsLoaded else {
            print("Products are already loaded.")
            return
        }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
        print("Products loaded: \(products)")
    }

    // 구매 메서드
    func purchase(_ product: Product) async throws {
        print("Attempting to purchase: \(product)")
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            print("Purchase successful and verified for product ID: \(transaction.productID)")
            await transaction.finish()
            await self.updatePurchasedProducts()

            // 영수증 데이터를 가져와 출력
            if let receiptData = fetchReceiptData() {
                print("Receipt Data: \(receiptData)")
            } else {
                print("Failed to retrieve receipt data.")
            }

        case let .success(.unverified(_, error)):
            print("Purchase successful but verification failed: \(error.localizedDescription)")
        case .pending:
            print("Purchase is pending approval or SCA.")
        case .userCancelled:
            print("User cancelled the purchase.")
        @unknown default:
            print("An unknown state occurred during purchase.")
        }
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
    func fetchReceiptData() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: receiptURL.path) else {
            print("No receipt found.")
            return nil
        }
        
        do {
            let receiptData = try Data(contentsOf: receiptURL)
            let receiptString = receiptData.base64EncodedString(options: [])
            return receiptString
        } catch {
            print("Failed to fetch receipt data: \(error.localizedDescription)")
            return nil
        }
    }
}
