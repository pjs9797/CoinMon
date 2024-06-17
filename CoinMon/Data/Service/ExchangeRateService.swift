import Moya
import Foundation

enum ExchangeRateService {
    case getLatestRates
}

extension ExchangeRateService: TargetType {
    var baseURL: URL {
        return URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1")!
    }
    
    var path: String {
        switch self {
        case .getLatestRates:
            return "/currencies/usdt.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
