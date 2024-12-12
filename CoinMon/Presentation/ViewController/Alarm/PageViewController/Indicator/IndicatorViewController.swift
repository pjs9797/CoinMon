import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class IndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let mainIndicatorView = MainIndicatorView()
    
    init(with reactor: IndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.gray_99
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.mainIndicatorView.setLocalizedText()
                self?.mainIndicatorView.normalNoneIndicatorView.hbbImageView.image = LocalizationManager.shared.language == "ko" ? ImageManager.ExplainHyperBollingerBands_ko : ImageManager.ExplainHyperBollingerBands_en
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.loadSubscriptionStatus)
        reactor?.action.onNext(.loadIndicatorCoinDatas)
    }
}

extension IndicatorViewController {
    func bind(reactor: IndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IndicatorReactor){
        mainIndicatorView.subscriptionIndicatorView.indicatorTableView.rx.setDelegate(self).disposed(by: disposeBag)

        //subscriptionIndicatorView
        mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.rx.tap
            .map{ Reactor.Action.addIndicatorButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.subscriptionIndicatorView.indicatorTableView.rx.itemSelected
            .map{ Reactor.Action.subscriptionIndicatorItemSelected($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.normalNoneIndicatorView.trialButton.rx.tap
            .map{ Reactor.Action.trialButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //normalNoneIndicatorView
        mainIndicatorView.normalNoneIndicatorView.viewOtherIndicatorButton.rx.tap
            .map{ Reactor.Action.viewOtherIndicatorButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.normalNoneIndicatorView.maIndicatorView.explainButton.rx.tap
            .map{ Reactor.Action.maExplainButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.normalNoneIndicatorView.maIndicatorView.selectOtherCoinButton.rx.tap
            .map{ Reactor.Action.maSelectOtherCoinButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //subscriptionNoneIndicatorView
        mainIndicatorView.subscriptionNoneIndicatorView.hbbIndicatorView.explainButton.rx.tap
            .map{ Reactor.Action.hbbExplainButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.subscriptionNoneIndicatorView.hbbIndicatorView.selectOtherCoinButton.rx.tap
            .map{ Reactor.Action.hbbSelectOtherCoinButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.subscriptionNoneIndicatorView.maIndicatorView.explainButton.rx.tap
            .map{ Reactor.Action.maExplainButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainIndicatorView.subscriptionNoneIndicatorView.maIndicatorView.selectOtherCoinButton.rx.tap
            .map{ Reactor.Action.maSelectOtherCoinButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: IndicatorReactor){
        Observable.combineLatest(
            reactor.state.map { $0.subscriptionStatus }.distinctUntilChanged(),
            reactor.state.map { $0.indicatorCoinDatas }.distinctUntilChanged()
        )
        .skip(1)
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] subscriptionStatus, indicatorCoinDatas in
            let status = subscriptionStatus.status
            if status == .normal && subscriptionStatus.useTrialYN == "N" && indicatorCoinDatas.isEmpty {
                self?.mainIndicatorView.show(view: self?.mainIndicatorView.normalNoneIndicatorView ?? UIView())
            }
            else if (status == .trial || status == .subscription) && indicatorCoinDatas.isEmpty {
                self?.mainIndicatorView.show(view: self?.mainIndicatorView.subscriptionNoneIndicatorView ?? UIView())
            }
            else {
                self?.mainIndicatorView.show(view: self?.mainIndicatorView.subscriptionIndicatorView ?? UIView())
            }
        })
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.indicatorCoinDatas }.distinctUntilChanged(),
            LocalizationManager.shared.rxLanguage
        )
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] indicatorCoinDatas, _ in
            let indicatorCoinDataCnt = indicatorCoinDatas.count
            if indicatorCoinDataCnt == 3 {
                if indicatorCoinDatas.first == IndicatorCoinData(indicatorId: 0, indicatorCoinId: "", indicatorName: "", indicatorNameEng: "", isPremium: "", frequency: "", coinName: "", isOn: "", curPrice: 0, recentTime: "", recentPrice: 0, timing: "") {
                    self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가"), for: .normal)
                    self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.isEnabled = true
                    self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitleColor(ColorManager.gray_20, for: .normal)
                }
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitle(LocalizationManager.shared.localizedString(forKey: "추가할 수 있는 알람을 모두 추가했어요"), for: .normal)
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.isEnabled = false
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitleColor(ColorManager.gray_90, for: .normal)
            } else {
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가"), for: .normal)
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.isEnabled = true
                self?.mainIndicatorView.subscriptionIndicatorView.addIndicatorButton.setTitleColor(ColorManager.gray_20, for: .normal)
            }
            
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicatorCoinDatas }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: mainIndicatorView.subscriptionIndicatorView.indicatorTableView.rx.items) { tableView, index, indicatorCoinData in
                if index == 0 && reactor.currentState.subscriptionStatus.status == .normal && reactor.currentState.subscriptionStatus.useTrialYN == "Y" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotSubscriptionIndicatorTableViewCell", for: IndexPath(row: index, section: 0)) as? NotSubscriptionIndicatorTableViewCell else {
                                    fatalError("셀을 캐스팅할 수 없습니다.")
                                }
                    LocalizationManager.shared.rxLanguage
                        .subscribe(onNext: { [weak cell] _ in
                            cell?.indicatorTitleLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드"))
                            cell?.noticeButton.configuration?.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "기간이 종료됐어요"), attributes: .init([.font: FontManager.H6_14]))
                            cell?.subscribeButton.configuration?.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "프리미엄 구독하기"), attributes: .init([.font: FontManager.D8_14]))
                            cell?.frequencyLabel.text = LocalizationManager.shared.localizedString(forKey: "분 마다 알림", arguments: "15")
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.explainButton.rx.tap
                        .map{ Reactor.Action.explainButtonTapped("1") }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    cell.subscribeButton.rx.tap
                        .map{ Reactor.Action.trialButtonTapped }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                } 
                else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorTableViewCell", for: IndexPath(row: index, section: 0)) as? IndicatorTableViewCell else {
                                    fatalError("셀을 캐스팅할 수 없습니다.")
                                }
                    cell.configure(with: indicatorCoinData)
                    
                    LocalizationManager.shared.rxLanguage
                        .subscribe(onNext: { [weak cell] language in
                            if language == "ko" {
                                cell?.indicatorTitleLabel.updateAttributedText(indicatorCoinData.indicatorName)
                            } else {
                                cell?.indicatorTitleLabel.updateAttributedText(indicatorCoinData.indicatorNameEng)
                            }
                            cell?.frequencyLabel.text = LocalizationManager.shared.localizedString(forKey: "분 마다 알림", arguments: indicatorCoinData.frequency)
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.explainButton.rx.tap
                        .map { Reactor.Action.explainButtonTapped(String(indicatorCoinData.indicatorId)) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    cell.alarmSwitch.rx.isOn.changed
                        .map { Reactor.Action.alarmSwitchTapped(indicatorId: String(indicatorCoinData.indicatorId), isOn: $0) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    let indicatorNm = LocalizationManager.shared.language == "ko" ? indicatorCoinData.indicatorName : indicatorCoinData.indicatorNameEng
                    
                    cell.rightButton.rx.tap
                        .map { Reactor.Action.rightButtonTapped(indicatorId: String(indicatorCoinData.indicatorId), indicatorCoinId: indicatorCoinData.indicatorCoinId, coin: indicatorCoinData.coinName, price: String(indicatorCoinData.curPrice), indicatorName: indicatorNm, frequency: indicatorCoinData.frequency) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
                
        reactor.state.map { $0.maIndicatorCoinDatas }
            .distinctUntilChanged()
            .bind(to: mainIndicatorView.normalNoneIndicatorView.maIndicatorView.indicatorAlarmTableView.rx.items(cellIdentifier: "IndicatorAlarmTableViewCell", cellType: IndicatorAlarmTableViewCell.self)) { index, coinTitle, cell in
                
                cell.configure(title: coinTitle)
                
                cell.alarmButton.rx.tap
                    .map{ Reactor.Action.maIndicatorItemSelected }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hbbIndicatorCoinDatas }
            .distinctUntilChanged()
            .bind(to: mainIndicatorView.subscriptionNoneIndicatorView.hbbIndicatorView.indicatorAlarmTableView.rx.items(cellIdentifier: "IndicatorAlarmTableViewCell", cellType: IndicatorAlarmTableViewCell.self)) { index, coinTitle, cell in
                
                cell.configure(title: coinTitle)
                
                cell.alarmButton.rx.tap
                    .map{ Reactor.Action.hbbIndicatorItemSelected }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.maIndicatorCoinDatas }
            .distinctUntilChanged()
            .bind(to: mainIndicatorView.subscriptionNoneIndicatorView.maIndicatorView.indicatorAlarmTableView.rx.items(cellIdentifier: "IndicatorAlarmTableViewCell", cellType: IndicatorAlarmTableViewCell.self)) { index, coinTitle, cell in
                
                cell.configure(title: coinTitle)
                
                cell.alarmButton.rx.tap
                    .map{ Reactor.Action.maIndicatorItemSelected }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension IndicatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) as? NotSubscriptionIndicatorTableViewCell {
            return nil // 선택 자체를 방지
        }
        return indexPath
    }
}
