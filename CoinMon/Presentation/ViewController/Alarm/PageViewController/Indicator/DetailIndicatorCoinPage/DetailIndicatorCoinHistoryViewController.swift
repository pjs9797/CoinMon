import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class DetailIndicatorCoinHistoryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let detailIndicatorCoinHistoryView = DetailIndicatorCoinHistoryView()
    
    init(with reactor: DetailIndicatorCoinHistoryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = detailIndicatorCoinHistoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.startTimer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.reactor?.action.onNext(.stopTimer)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.refreshIndicatorHistory)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] notification in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. MM. dd HH:mm"
                let formattedTime = dateFormatter.string(from: Date())
                self?.detailIndicatorCoinHistoryView.toastMessage.toastLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "업데이트가 완료 되었어요", arguments: formattedTime))
                self?.showToastMessage(self?.detailIndicatorCoinHistoryView.toastMessage ?? UIView())
            })
            .disposed(by: disposeBag)
    }
    
    private func showToastMessage(_ toastView: UIView) {
        toastView.isHidden = false
        view.bringSubviewToFront(toastView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toastView.isHidden = true
        }
    }
}

extension DetailIndicatorCoinHistoryViewController {
    func bind(reactor: DetailIndicatorCoinHistoryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailIndicatorCoinHistoryReactor){
        detailIndicatorCoinHistoryView.timingTypeSegmentedControl.rx.selectedSegmentIndex
            .map { Reactor.Action.changeTimingType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailIndicatorCoinHistoryReactor){
        reactor.state.map { $0.indicatorCoinHistories }
            .distinctUntilChanged()
            .bind(to: detailIndicatorCoinHistoryView.indicatorHistoryTableView.rx.items(cellIdentifier: "IndicatorHistoryTableViewCell", cellType: IndicatorHistoryTableViewCell.self)) { (index, indicatorCoinHistories, cell) in
                cell.configure(with: indicatorCoinHistories)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmptyIndicatorCoinHistories }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEmpty in
                if isEmpty {
                    self?.detailIndicatorCoinHistoryView.isEmptyHistory()
                }
                else {
                    self?.detailIndicatorCoinHistoryView.isNotEmptyHistory()
                }
            })
            .disposed(by: disposeBag)
    }
}
