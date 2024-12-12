import ReactorKit
import RxCocoa
import RxFlow
import UIKit

class DetailIndicatorCoinReactor: ReactorKit.Reactor, Stepper {
    private var timerDisposable: Disposable?
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorCoinId: String, coin: String, price: String, indicatorName: String, frequency: String){
        let coinTitle = "\(coin)(USDT)"
        
        self.indicatorUseCase = indicatorUseCase
        self.initialState = State(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId, coin: coin, coinTitle: coinTitle, coinPrice: "$\(price)", indicatorName: indicatorName, frequency: frequency)
    }
    
    enum Action {
        case backButtonTapped
        case moreButtonTapped
        case goToBinanceButtonTapped
        
        case selectItem(Int)
        case setPreviousIndex(Int)
        case loadIndicatorCoinHistory
        
        case startTimer
        case stopTimer
    }
    
    enum Mutation {
        case setSelectedItem(Int)
        case setPreviousIndex(Int)
        case setIndicatorCoinHistory(IndicatorCoinHistory?)
    }
    
    struct State {
        var selectedItem: Int = 0
        var previousIndex: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "차트"),
            LocalizationManager.shared.localizedString(forKey: "히스토리")
        ]
        var indicatorId: String
        var indicatorCoinId: String
        var coin: String
        var coinTitle: String
        var coinPrice: String
        var indicatorName: String
        var frequency: String
        var indicatorCoinHistory: IndicatorCoinHistory?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .moreButtonTapped:
            self.steps.accept(AlarmStep.presentToMoreButtonAtIndicatorSheetPresentationController(indicatorId: currentState.indicatorId, indicatorName: currentState.indicatorName, frequency: currentState.frequency))
            return .empty()
        case .goToBinanceButtonTapped:
            let binanceAppURL = URL(string: "binance://")!
            let appStoreURL = URL(string: "https://apps.apple.com/app/binance/id1436799971")!
            
            if UIApplication.shared.canOpenURL(binanceAppURL) {
                UIApplication.shared.open(binanceAppURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
            return .empty()
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .setPreviousIndex(let index):
            return .just(.setPreviousIndex(index))
        case .loadIndicatorCoinHistory:
            return indicatorUseCase.getIndicatorCoinHistory(indicatorId: currentState.indicatorId, indicatorCoinId: currentState.indicatorCoinId)
                .flatMap { indicatorCoinHistories -> Observable<Mutation> in
                    let indicatorCoinHistory = indicatorCoinHistories.first
                    return .just(.setIndicatorCoinHistory(indicatorCoinHistory))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
            
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedItem(let index):
            newState.selectedItem = index
        case .setPreviousIndex(let index):
            newState.previousIndex = index
        case .setIndicatorCoinHistory(let indicatorCoinHistory):
            newState.indicatorCoinHistory = indicatorCoinHistory
        }
        return newState
    }
    
    private func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard UIApplication.shared.applicationState == .active else {
                    print("앱이 백그라운드 상태입니다. API 호출 중단")
                    return
                }
                self?.action.onNext(.loadIndicatorCoinHistory)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
}
