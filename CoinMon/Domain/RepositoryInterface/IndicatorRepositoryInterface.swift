import Foundation
import RxSwift

protocol IndicatorRepositoryInterface {
    func getIndicator() -> Observable<[GetIndicatorData]>
    func getIndicatorCoinData() -> Observable<[IndicatorCoinData]>
    func getIndicatorCoinDataDetail(indicatorId: String) -> Observable<[IndicatorCoinData]>
    func getUpdateIndicatorCoinDataDetail(indicatorId: String) -> Observable<[UpdateSelectedIndicatorCoin]>
    func getIndicatorCoinList(indicatorId: String) -> Observable<[IndicatorCoinPriceChange]>
    func updateIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String>
    func updateIndicatorPushState(indicatorId: String, isOn: String) -> Observable<String>
    func createIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String>
    func getIndicatorCoinHistory(indicatorId: String, indicatorCoinId: String) -> Observable<[IndicatorCoinHistory]>
    func deleteIndicatorPush(indicatorId: String) -> Observable<String>
}
