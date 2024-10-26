import ReactorKit
import RxCocoa
import RxFlow

class SurveyReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let termsOfServiceFlow: TermsOfServiceFlow
    
    init(termsOfServiceFlow: TermsOfServiceFlow){
        self.termsOfServiceFlow = termsOfServiceFlow
    }
    
    enum Action {
        case completeButtonTapped
        case selectItem(index: Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var surveyItems: [[String]] = [
            [LocalizationManager.shared.localizedString(forKey: "입문"),LocalizationManager.shared.localizedString(forKey: "보조지표, 차트 분석 등 아무것도 몰라요")],
            [LocalizationManager.shared.localizedString(forKey: "초급"),LocalizationManager.shared.localizedString(forKey: "보조지표는 조금 알지만 차트 분석은 할 줄 몰라요")],
            [LocalizationManager.shared.localizedString(forKey: "중급"),LocalizationManager.shared.localizedString(forKey: "매매에 자주 사용하는 보조지표가 있어요")],
            [LocalizationManager.shared.localizedString(forKey: "고급"),LocalizationManager.shared.localizedString(forKey: "보조지표들을 조합한 나만의 전략이 있어요")],
            [LocalizationManager.shared.localizedString(forKey: "전문가"),LocalizationManager.shared.localizedString(forKey: "나만의 전략으로 꾸준히 수익을 내고 있어요")],
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .completeButtonTapped:
            return .empty()
        case .selectItem(let index):
            return .empty()
        }
    }
}
