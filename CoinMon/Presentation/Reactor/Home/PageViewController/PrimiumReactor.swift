import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class PremiumReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case departureExchangeButtonTapped
        case arrivalExchangeButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var premiumList: [PremiumList] = [
            PremiumList(coinImage: "bybit", coinTitle: "BTC", premium: "0.01"),
            PremiumList(coinImage: "bybit", coinTitle: "ETH", premium: "0.03"),
            PremiumList(coinImage: "bybit", coinTitle: "XRP", premium: "0.05"),
            PremiumList(coinImage: "bybit", coinTitle: "SOL", premium: "0.005"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .departureExchangeButtonTapped:
            self.steps.accept(HomeStep.presentToSelectDepartureExchangeViewController)
            return .empty()
        case .arrivalExchangeButtonTapped:
            self.steps.accept(HomeStep.presentToSelectArrivalExchangeViewController)
            return .empty()
        }
    }
}
