import Moya

struct MoyaProviderUtils {
    static let requestClosure: MoyaProvider<MultiTarget>.RequestClosure = { (endpoint, done) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
}
