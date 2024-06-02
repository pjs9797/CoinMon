import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class PremiumReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case departureMarketButtonTapped
        case arrivalMarketButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var premiumList: [PremiumList] = [
            PremiumList(coinTitle: "BTC", premium: "0.01"),
            PremiumList(coinTitle: "ETH", premium: "0.03"),
            PremiumList(coinTitle: "XRP", premium: "0.05"),
            PremiumList(coinTitle: "SOL", premium: "0.005"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .departureMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectDepartureMarketViewController)
            return .empty()
        case .arrivalMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectArrivalMarketViewController)
            return .empty()
        }
    }
}
