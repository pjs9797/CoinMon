import UIKit
import ReactorKit

class MarketingConsentViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let termsOfServiceView = TermsOfServiceView()
    
    init(with reactor: MarketingConsentReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = termsOfServiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        view.backgroundColor = .white
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "마케팅 정보 수신 동의")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension MarketingConsentViewController {
    func bind(reactor: MarketingConsentReactor) {
        bindAction(reactor: reactor)
    }
    
    func bindAction(reactor: MarketingConsentReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
