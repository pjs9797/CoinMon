import Foundation
import Moya
import Alamofire

class MoyaRequestInterceptor: RequestInterceptor {
    private let retryLimit = 2
    private var retryCount = 0
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization-refresh")
        }
        
        completion(.success(request))
    }
    
    // 401 응답 시 처리 및 재시도
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard retryCount < retryLimit,
              let response = request.response,
              response.statusCode == 401 else {
            // 최대 재시도 횟수 초과 또는 401이 아닌 경우
            completion(.doNotRetry)
            return
        }
        
        retryCount += 1
        
        // 응답 헤더에서 Authorization 값 가져오기
        if let accessToken = response.headers["Authorization"] {
            // TokenManager에 새로운 AccessToken 저장
            TokenManager.shared.saveAccessToken(accessToken)
            
            // 요청 재시도
            completion(.retry)
        } else {
            // Authorization 헤더가 없으면 재시도하지 않음
            completion(.doNotRetry)
        }
    }
}
