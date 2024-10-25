import ReactorKit
import RxCocoa
import RxFlow

class SelectIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase) {
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case backButtonTapped
        case explainButtonTapped(indicatorId: String)
        case rightButtonTapped(isPushed: Bool, indicatorId: String, indicatorName: String, isPremium: Bool)
        case selectCategory(Int)
    }
    
    enum Mutation {
        case setIndicators([IndicatorInfo])
        case setSelectedCategory(Int)
    }
    
    struct State {
        var selectedCategory: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "전체"),
            LocalizationManager.shared.localizedString(forKey: "프리미엄"),
            LocalizationManager.shared.localizedString(forKey: "무료")
        ]
        var indicators: [IndicatorInfo] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .explainButtonTapped(let indicatorId):
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId))
            return .empty()
        case .rightButtonTapped(let isPushed, let indicatorId, let indicatorName, let isPremium):
            if isPushed {
                
            }
            else {
                self.steps.accept(AlarmStep.navigateToSelectCoinForIndicatorViewController(indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium))
            }
            return .empty()
        case .selectCategory(let index):
            return indicatorUseCase.getIndicatorInfo(language: LocalizationManager.shared.language, categoryIndex: index)
                .flatMap { indicatorInfo -> Observable<Mutation> in
                    
                    return .concat([
                        .just(.setIndicators(indicatorInfo)),
                        .just(.setSelectedCategory(index))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIndicators(let indicators):
            newState.indicators = indicators
        case .setSelectedCategory(let index):
            newState.selectedCategory = index
        }
        return newState
    }
}
