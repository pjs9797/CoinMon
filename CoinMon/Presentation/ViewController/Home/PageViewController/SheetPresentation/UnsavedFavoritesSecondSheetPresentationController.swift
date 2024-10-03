import UIKit
import ReactorKit

class UnsavedFavoritesSecondSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let unsavedFavoritesChangeSecondView = UnsavedFavoritesChangeSecondView()
    
    init(with reactor: UnsavedFavoritesSecondReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = unsavedFavoritesChangeSecondView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension UnsavedFavoritesSecondSheetPresentationController {
    func bind(reactor: UnsavedFavoritesSecondReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: UnsavedFavoritesSecondReactor){
        unsavedFavoritesChangeSecondView.continueButton.rx.tap
            .map{ Reactor.Action.continueButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        unsavedFavoritesChangeSecondView.moveButton.rx.tap
            .map{ Reactor.Action.moveButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: UnsavedFavoritesSecondReactor){
    }
}
