import Foundation
import RxSwift

protocol IndicatorRepositoryInterface {
    func getIndicator() -> Observable<[GetIndicatorData]>
    func getIndicatorPushOnly() -> Observable<[GetIndicatorPush]>
    func getIndicatorCoinList(indicatorId: String) -> Observable<[IndicatorCoinPriceChange]>
    func createIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String>
}
