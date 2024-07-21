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
    
    override func loadView() {
        super.loadView()
        
        view = notificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
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
    }
    
    func bindState(reactor: NotificationReactor){
        reactor.state.map{ $0.isNotificationEnabled }
            .distinctUntilChanged()
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
                    self?.notificationView.notificationTableViewFooter.isHidden = true
                }
                else {
                    self?.notificationView.noneNotificationView.isHidden = true
                    self?.notificationView.notificationTableViewFooter.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
    }
}
