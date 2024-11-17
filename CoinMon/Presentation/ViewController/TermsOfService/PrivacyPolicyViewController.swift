import UIKit
import ReactorKit

class PrivacyPolicyViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let privacyPolicyView = PrivacyPolicyView()
    
    init(with reactor: PrivacyPolicyReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = privacyPolicyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        view.backgroundColor = ColorManager.common_100
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "개인정보 처리방침")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension PrivacyPolicyViewController {
    func bind(reactor: PrivacyPolicyReactor) {
        bindAction(reactor: reactor)
    }
    
    func bindAction(reactor: PrivacyPolicyReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
