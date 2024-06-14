import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectCoinViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectCoinView = SelectCoinView()
    
    init(with reactor: SelectCoinReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCoinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.selectCoinView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadCoinData)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "코인 선택")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SelectCoinViewController {
    func bind(reactor: SelectCoinReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCoinReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinView.selectCoinTableView.rx.itemSelected
            .map { Reactor.Action.selectCoin($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCoinReactor){
        reactor.state.map { $0.coins }
            .distinctUntilChanged()
            .bind(to: selectCoinView.selectCoinTableView.rx.items(cellIdentifier: "SelectCoinTableViewCell", cellType: SelectCoinTableViewCell.self)){ row, coin, cell in
                
                cell.configurePrice(with: coin)
            }
            .disposed(by: disposeBag)
    }
}
