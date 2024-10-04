import UIKit
import ReactorKit
import SnapKit

class HomeViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let homeCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2*ConstantsManager.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCategoryCollectionViewCell")
        return collectionView
    }()
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.notification24, for: .normal)
        button.accessibilityIdentifier = "notificationButton"
        return button
    }()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: HomeReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        pageViewController.dataSource = self
        pageViewController.delegate = self
        layout()
        notificationCheck()
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedCategories)
            })
            .disposed(by: disposeBag)
        
        if let accessToken = TokenManager.shared.loadAccessToken(){
            print("accessToken : ",accessToken)
        }
        if let refreshToken = TokenManager.shared.loadRefreshToken(){
            print("refreshToken : ",refreshToken)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func notificationCheck(){
        NotificationCenter.default.rx.notification(Notification.Name("didReceiveRemoteNotification"))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.receivedNewNotification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("notificationViewControllerDidAppear"))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.viewedNotifications)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout(){
        [homeCategoryCollectionView,notificationButton]
            .forEach{
                view.addSubview($0)
            }
        
        view.addSubview(pageViewController.view)
        
        homeCategoryCollectionView.snp.makeConstraints { make in
            make.width.equalTo(355*ConstantsManager.standardWidth)
            make.height.equalTo(42*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7*ConstantsManager.standardHeight)
        }
        
        notificationButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(homeCategoryCollectionView)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(homeCategoryCollectionView.snp.bottom).offset(3*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension HomeViewController {
    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: HomeReactor){
        homeCategoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        homeCategoryCollectionView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap
            .map{ Reactor.Action.alarmCenterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: HomeReactor){
        reactor.state.map { $0.selectedItem }
            .observe(on:MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                let direction: UIPageViewController.NavigationDirection = (index > reactor.currentState.previousIndex) ? .forward : .reverse
                self?.pageViewController.setViewControllers([self!.viewControllers[index]], direction: direction, animated: true, completion: nil)
                self?.homeCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                reactor.action.onNext(.setPreviousIndex(index))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: homeCategoryCollectionView.rx.items(cellIdentifier: "HomeCategoryCollectionViewCell", cellType: HomeCategoryCollectionViewCell.self)) { (index, categories, cell) in
                let isSelected = index == reactor.currentState.selectedItem
                cell.isSelected = isSelected
                if isSelected {
                    self.homeCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hasNewNotifications }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] hasNewNotifications in
                let image = hasNewNotifications ? ImageManager.notification_select24 : ImageManager.notification24
                self?.notificationButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < (viewControllers.count - 1) else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: visibleViewController) {
            homeCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectItem(index))
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.categories[index]) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.D3_22
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 42*ConstantsManager.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+12)*ConstantsManager.standardWidth, height: 42*ConstantsManager.standardHeight)
    }
}
