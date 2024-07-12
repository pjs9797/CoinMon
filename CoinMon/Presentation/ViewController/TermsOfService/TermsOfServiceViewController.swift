import UIKit
import ReactorKit

class TermsOfServiceViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let termsOfServiceView = TermsOfServiceView()
    
    init(with reactor: TermsOfServiceReactor) {
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
        view.backgroundColor = .systemBackground
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "서비스 이용약관")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension TermsOfServiceViewController {
    func bind(reactor: TermsOfServiceReactor) {
        bindAction(reactor: reactor)
    }
    
    func bindAction(reactor: TermsOfServiceReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
