import ReactorKit
import RxCocoa
import RxFlow

class ExplainIndicatorSheetPresentationReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init(indicatorId: String) {
        var indicatorLabelText = ""
        var explainLabelText = ""
        switch indicatorId {
        case "1":
            indicatorLabelText = LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드")
            explainLabelText = LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저 밴드는 기존 볼린저 밴드와 역추세 전략을 결합한 코인몬만의 고급지표예요. 가격이 밴드 안에서 좁아질 때는 매매 기회를 찾고, 가격이 밴드를 크게 벗어나면 강한 추세가 시작될 신호로 보고 매수나 매도를 더 정확하게 할 수 있게 도와줘요.")
        case "2":
            indicatorLabelText = LocalizationManager.shared.localizedString(forKey: "이동평균선")
            explainLabelText = LocalizationManager.shared.localizedString(forKey: "일정 기간 동안 주가의 평균값을 연결한 지표에요. 현재 주가가 어느정도 위치해 있는지 판단할 수 있어요. 후행성 지표이기 때문에 미래를 예측하는 것 보다 현재 상태를 확인하고 분석하는데 도움을 줘요.")
        case "3":
            indicatorLabelText = LocalizationManager.shared.localizedString(forKey: "RSI")
            explainLabelText = LocalizationManager.shared.localizedString(forKey: "일정 기간 동안 가격 변화 속도와 크기를 측정하여 현재 가격이 과매수 혹은 과매도 상태인지 판단하는 데 도움을 줘요.")
        default:
            break
        }
        self.initialState = State(indicatorLabelText: indicatorLabelText, explainLabelText: explainLabelText)
    }
    
    enum Action {
        case okButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var indicatorLabelText: String
        var explainLabelText: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .okButtonTapped:
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
