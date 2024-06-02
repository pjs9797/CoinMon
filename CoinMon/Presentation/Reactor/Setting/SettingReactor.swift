import ReactorKit
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init() {
        self.initialState = State(currentLanguage: LocalizationManager.shared.language)
    }
    
    enum Action {
        case changeLanguage(String)
    }
    
    enum Mutation {
        case setLanguage(String)
    }
    
    struct State {
        var currentLanguage: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeLanguage(let newLanguage):
            LocalizationManager.shared.setLanguage(newLanguage)
            return Observable.just(.setLanguage(newLanguage))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLanguage(let newLanguage):
            newState.currentLanguage = newLanguage
        }
        return newState
    }
}
