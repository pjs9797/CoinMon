import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class UpdateIndicatorCoinViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let deleteAllButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(forKey: "삭제"), style: .plain, target: nil, action: nil)
    let updateIndicatorCoinView = UpdateIndicatorCoinView()
    
    init(with reactor: UpdateIndicatorCoinReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = updateIndicatorCoinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        self.reactor?.action.onNext(.loadIndicatorCoinDatas)
    }
    
    private func setNavigationbar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_40 ?? .gray,
            .font: FontManager.B3_16
        ]
        deleteAllButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteAllButton
    }
}

extension UpdateIndicatorCoinViewController {
    func bind(reactor: UpdateIndicatorCoinReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: UpdateIndicatorCoinReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteAllButton.rx.tap
            .map{ Reactor.Action.deleteAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        updateIndicatorCoinView.selectButton.rx.tap
            .map{ Reactor.Action.selectButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        updateIndicatorCoinView.saveButton.rx.tap
            .map{ Reactor.Action.saveButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.selectCoinRelay
            .observe(on:MainScheduler.asyncInstance)
            .map{ Reactor.Action.loadSelectCoinDatas($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: UpdateIndicatorCoinReactor){
        reactor.state.map{ $0.indicatorName }
            .distinctUntilChanged()
            .observe(on:MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] indicatorName in
                self?.title = indicatorName
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicatorCoinDatas }
            .distinctUntilChanged()
            .observe(on:MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] indicatorCoinDatas in
                let cnt = indicatorCoinDatas.count
                let text = LocalizationManager.shared.localizedString(forKey: "코인")
                self?.updateIndicatorCoinView.indicatorCoinCntLabel.text = "\(text) \(cnt)/3"
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicatorCoinDatas }
            .distinctUntilChanged()
            .observe(on:MainScheduler.asyncInstance)
            .bind(to: updateIndicatorCoinView.updateIndicatorCoinTableView.rx.items(cellIdentifier: "UpdateIndicatorCoinTableViewCell", cellType: UpdateIndicatorCoinTableViewCell.self)) { index, indicatorCoinData, cell in
                
                cell.configure(with: indicatorCoinData)
                
                cell.pinButton.rx.tap
                    .map { Reactor.Action.pinButtonTapped(index) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.deleteButton.rx.tap
                    .map { Reactor.Action.deleteButtonTapped(index) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.saveButtonEnabled }
            .distinctUntilChanged()
            .observe(on:MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] isEnabled in
                if isEnabled {
                    self?.updateIndicatorCoinView.saveButton.isEnable()
                }
                else {
                    self?.updateIndicatorCoinView.saveButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
