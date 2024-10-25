import Foundation
import RxSwift

class IndicatorUseCase {
    private let repository: IndicatorRepositoryInterface

    init(repository: IndicatorRepositoryInterface) {
        self.repository = repository
    }

    func getIndicatorInfo(language: String, categoryIndex: Int) -> Observable<[IndicatorInfo]> {
        let indicatorsObservable = repository.getIndicator()
        let pushesObservable = repository.getIndicatorPushOnly()
        
        return Observable.zip(indicatorsObservable, pushesObservable) { indicators, pushes in
            let pushIds = Set(pushes.map { $0.indicatorId })
            
            let allIndicators = indicators.map { indicator in
                let isPushed = pushIds.contains(indicator.indicatorId)
                let indicatorName = language == "ko" ? indicator.indicatorName : indicator.indicatorNameEng
                let indicatorDescription = language == "ko" ? indicator.indicatorDescription : indicator.indicatorDescriptionEng
                
                return IndicatorInfo(
                    indicatorId: indicator.indicatorId,
                    indicatorName: indicatorName,
                    indicatorDescription: indicatorDescription,
                    isPremiumYN: indicator.isPremiumYN,
                    isPushed: isPushed
                )
            }
            
            switch categoryIndex {
            case 0:
                return allIndicators // 전체
            case 1:
                return allIndicators.filter { $0.indicatorId == 1 } // indicatorId가 1인 것만
            case 2:
                return allIndicators.filter { $0.indicatorId != 1 } // indicatorId가 1이 아닌 나머지
            default:
                return allIndicators
            }
        }
    }
    
    func getIndicatorCoinList(indicatorId: String) -> Observable<[IndicatorCoinPriceChange]> {
        return repository.getIndicatorCoinList(indicatorId: indicatorId)
    }
    
    func createIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String> {
        return repository.createIndicatorPush(indicatorId: indicatorId, frequency: frequency, targets: targets)
    }
}
