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
            PremiumList(coinImage: "bybit", coinTitle: "BTC", premium: "0.01"),
            PremiumList(coinImage: "bybit", coinTitle: "ETH", premium: "0.03"),
            PremiumList(coinImage: "bybit", coinTitle: "XRP", premium: "0.05"),
            PremiumList(coinImage: "bybit", coinTitle: "SOL", premium: "0.005"),
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
