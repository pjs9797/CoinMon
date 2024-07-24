import UIKit
import ReactorKit

class NotificationViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let notificationView = NotificationView()
    
    init(with reactor: NotificationReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        
        view = notificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        reactor?.action.onNext(.loadNotifications)
        reactor?.action.onNext(.checkNotificationStatus)
        setNavigationbar()
        notificationCheck()
        UserDefaults.standard.setValue(false, forKey: "didReceiveNotificationAtBackground")
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.notificationView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "알림")
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func notificationCheck(){
        NotificationCenter.default.post(name: Notification.Name("notificationViewControllerDidAppear"), object: nil)

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.checkNotificationStatus)
            })
            .disposed(by: disposeBag)
    }
}

extension NotificationViewController {
    func bind(reactor: NotificationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: NotificationReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationView.setAlarmButton.rx.tap
            .map{ Reactor.Action.alarmSettingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationView.upButton.rx.tap
            .map{ Reactor.Action.upButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationView.notificationTableView.rx.contentOffset
            .map { Reactor.Action.scrollViewDidScroll($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: NotificationReactor){
        reactor.state.map{ $0.isNotificationEnabled }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] isEnabled in
                if isEnabled {
                    self?.notificationView.updateLayoutSetAlarm()
                }
                else {
                    self?.notificationView.updateLayoutNotSetAlarm()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.notifications }
            .distinctUntilChanged()
            .bind(to: notificationView.notificationTableView.rx.items(cellIdentifier: "NotificationTableViewCell", cellType: NotificationTableViewCell.self)) { index, notification, cell in
                cell.configure(with: notification)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.notifications }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] notifications in
                if notifications.isEmpty {
                    self?.notificationView.noneNotificationView.isHidden = false
                    self?.notificationView.notificationTableView.tableFooterView!.isHidden = true
                }
                else {
                    self?.notificationView.noneNotificationView.isHidden = true
                    self?.notificationView.notificationTableView.tableFooterView!.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isScrolledToTop }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] shouldScroll in
                self?.notificationView.notificationTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.scrollPosition.y <= 0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: notificationView.upButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
