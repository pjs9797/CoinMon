import ReactorKit
import RxCocoa
import RxFlow

class InquiryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case discordButtonTapped
        case kakaoButtonTapped
        case telegramButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .discordButtonTapped:
            let discordURL = "https://discord.gg/JVGbZDNY"
            let discordAppStoreURL = "itms-apps://itunes.apple.com/app/id985746746"
            self.steps.accept(SettingStep.goToOpenURL(url: discordURL, fallbackUrl: discordAppStoreURL))
            return .empty()
        case .kakaoButtonTapped:
            let kakaoURL = "https://open.kakao.com/o/gxZ2CNtg"
            let kakaoAppStoreURL = "itms-apps://itunes.apple.com/app/id362057947"
            self.steps.accept(SettingStep.goToOpenURL(url: kakaoURL, fallbackUrl: kakaoAppStoreURL))
            return .empty()
        case .telegramButtonTapped:
            let telegramURL = "https://t.me/+mKnXAokQ3Uo3Zjg9"
            let telegramAppStoreURL = "itms-apps://itunes.apple.com/app/id686449807"
            self.steps.accept(SettingStep.goToOpenURL(url: telegramURL, fallbackUrl: telegramAppStoreURL))
            return .empty()
        }
    }
}
