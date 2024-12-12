import ReactorKit
import RxCocoa
import RxFlow

class SurveyReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let userUseCase = UserUseCase(repository: UserRepository())
    
    enum Action {
        case completeButtonTapped
        case selectItem(index: Int)
    }
    
    enum Mutation {
        case selectItem(Int)
    }
    
    struct State {
        var surveyItems: [[String]] = [
            [LocalizationManager.shared.localizedString(forKey: "입문"),LocalizationManager.shared.localizedString(forKey: "보조지표, 차트 분석 등 아무것도 몰라요")],
            [LocalizationManager.shared.localizedString(forKey: "초급"),LocalizationManager.shared.localizedString(forKey: "보조지표는 조금 알지만 차트 분석은 할 줄 몰라요")],
            [LocalizationManager.shared.localizedString(forKey: "중급"),LocalizationManager.shared.localizedString(forKey: "매매에 자주 사용하는 보조지표가 있어요")],
            [LocalizationManager.shared.localizedString(forKey: "고급"),LocalizationManager.shared.localizedString(forKey: "보조지표들을 조합한 나만의 전략이 있어요")],
            [LocalizationManager.shared.localizedString(forKey: "전문가"),LocalizationManager.shared.localizedString(forKey: "나만의 전략으로 꾸준히 수익을 내고 있어요")],
        ]
        var selectedIndex: Int = 0
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .completeButtonTapped:
            UserDefaultsManager.shared.setIsFirstLaunch(false)
            self.steps.accept(AppStep.navigateToSigninViewController)
            return .empty()
            //TODO: 회의 후 주석 제거
//            return userUseCase.postSurvey(answer: String(currentState.selectedIndex))
//                .flatMap { _ -> Observable<Mutation> in
//                    UserDefaultsManager.shared.setIsFirstLaunch(false)
//                    self.steps.accept(AppStep.navigateToSigninViewController)
//                    return .empty()
//                }
//                .catch { [weak self] error in
//                    ErrorHandler.handle(error) { (step: AppStep) in
//                        self?.steps.accept(step)
//                    }
//                    return .empty()
//                }
        case .selectItem(let index):
            return .just(.selectItem(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .selectItem(let selectedIndex):
            newState.selectedIndex = selectedIndex
        }
        return newState
    }
}
