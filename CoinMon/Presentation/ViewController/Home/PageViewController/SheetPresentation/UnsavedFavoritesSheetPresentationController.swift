import UIKit
import ReactorKit

class UnsavedFavoritesSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let unsavedFavoritesChangeView = UnsavedFavoritesChangeView()
    
    init(with reactor: UnsavedFavoritesReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = unsavedFavoritesChangeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension UnsavedFavoritesSheetPresentationController {
    func bind(reactor: UnsavedFavoritesReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: UnsavedFavoritesReactor){
        unsavedFavoritesChangeView.continueButton.rx.tap
            .map{ Reactor.Action.continueButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        unsavedFavoritesChangeView.finishButton.rx.tap
            .map{ Reactor.Action.finishButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: UnsavedFavoritesReactor){
    }
}
