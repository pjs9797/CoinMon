import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailIndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let alarmCenterButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(forKey: "알림센터"), style: .plain, target: nil, action: nil)

    let detailIndicatorView = DetailIndicatorView()
    
    init(with reactor: DetailIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = detailIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        setupNotifications()
    }
    
    private func setNavigationbar() {
        self.title = ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_40 ?? .gray,
            .font: FontManager.B3_16
        ]
        alarmCenterButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = alarmCenterButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.loadIndicatorCoinDatas)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.receiveTestAlarm)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] notification in
                self?.detailIndicatorView.toastMessage.toastLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "준비 완료! 타이밍에 알려드릴게요"))
                self?.showToastMessage(self?.detailIndicatorView.toastMessage ?? UIView())
            })
            .disposed(by: disposeBag)
    }
    
    private func showToastMessage(_ toastView: UIView) {
        toastView.isHidden = false
        view.bringSubviewToFront(toastView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toastView.isHidden = true
        }
    }
}

extension DetailIndicatorViewController {
    func bind(reactor: DetailIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailIndicatorReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmCenterButton.rx.tap
            .map{ Reactor.Action.alarmCenterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailIndicatorView.settingButton.rx.tap
            .map{ Reactor.Action.settingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailIndicatorView.receiveTestAlarmButton.rx.tap
            .map{ Reactor.Action.receiveTestAlarmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailIndicatorReactor){
        reactor.state.map{ $0.indicatorName }
            .distinctUntilChanged()
            .bind(to: detailIndicatorView.indicatorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.indicatorName }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] indicatorName in
                if reactor.currentState.flowType == "WhenCreate" {
                    self?.detailIndicatorView.toastMessage.toastLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "지표 알람을 등록했어요", arguments: indicatorName))
                    self?.showToastMessage(self?.detailIndicatorView.toastMessage ?? UIView())
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ !$0.isPremium }
            .distinctUntilChanged()
            .bind(to: detailIndicatorView.premiumLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.frequency }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] frequency in
                self?.detailIndicatorView.frequencyLabel.text = LocalizationManager.shared.localizedString(forKey: "분 마다 알림", arguments: frequency)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicatorCoinDatas }
            .distinctUntilChanged()
            .bind(to: detailIndicatorView.detailIndicatorTableView.rx.items(cellIdentifier: "DetailIndicatorTableViewCell", cellType: DetailIndicatorTableViewCell.self)) { index, indicatorCoinData, cell in
                
                cell.pinImageView.isHidden = index == 0 ? false : true
                cell.configure(with: indicatorCoinData)
                let isPremium = indicatorCoinData.isPremium == "Y" ? true : false
                
                cell.rightButton.rx.tap
                    .map{ Reactor.Action.rightButtonTapped(indicatorId: String(indicatorCoinData.indicatorId), indicatorCoinId: indicatorCoinData.indicatorCoinId, coin: indicatorCoinData.coinName, price: String(indicatorCoinData.curPrice)) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
