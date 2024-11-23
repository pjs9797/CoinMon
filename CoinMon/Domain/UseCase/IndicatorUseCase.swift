import Foundation
import RxSwift

class IndicatorUseCase {
    private let repository: IndicatorRepositoryInterface

    init(repository: IndicatorRepositoryInterface) {
        self.repository = repository
    }

    func getIndicatorInfo(language: String, categoryIndex: Int) -> Observable<[IndicatorInfo]> {
        let indicatorsObservable = repository.getIndicator()
        let indicatorCoinDataObservable = repository.getIndicatorCoinData()
        
        return Observable.zip(indicatorsObservable, indicatorCoinDataObservable) { indicators, indicatorCoinDatas in
            let pushIds = Set(indicatorCoinDatas.map { $0.indicatorId })
            
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
    
    func getIndicatorCoinData() -> Observable<[IndicatorCoinData]> {
        return repository.getIndicatorCoinData()
    }
    
    func getIndicatorCoinDataDetail(indicatorId: String) -> Observable<[IndicatorCoinData]> {
        return repository.getIndicatorCoinDataDetail(indicatorId: indicatorId)
    }
    
    func getUpdateIndicatorCoinDataDetail(indicatorId: String) -> Observable<[UpdateSelectedIndicatorCoin]> {
        return repository.getUpdateIndicatorCoinDataDetail(indicatorId: indicatorId)
    }
    
    func getIndicatorCoinList(indicatorId: String) -> Observable<[IndicatorCoinPriceChange]> {
        return repository.getIndicatorCoinList(indicatorId: indicatorId)
    }
    
    func updateIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String> {
        return repository.updateIndicatorPush(indicatorId: indicatorId, frequency: frequency, targets: targets)
    }
    
    func updateIndicatorPushState(indicatorId: String, isOn: String) -> Observable<String> {
        return repository.updateIndicatorPushState(indicatorId: indicatorId, isOn: isOn)
    }
    
    func createIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String> {
        return repository.createIndicatorPush(indicatorId: indicatorId, frequency: frequency, targets: targets)
    }
    
    func getIndicatorCoinHistory(indicatorId: String, indicatorCoinId: String) -> Observable<[IndicatorCoinHistory]> {
        return repository.getIndicatorCoinHistory(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId)
    }
    
    func deleteIndicatorPush(indicatorId: String) -> Observable<String> {
        return repository.deleteIndicatorPush(indicatorId: indicatorId)
    }
    
    func testPush() -> Observable<String> {
        return repository.testPush()
    }
}
