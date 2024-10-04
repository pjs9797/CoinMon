import UIKit
import ReactorKit
import SnapKit

class DetailCoinInfoViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let searchButton = UIBarButtonItem(image: ImageManager.icon_search24, style: .plain, target: nil, action: nil)
    let favoriteButton = UIBarButtonItem(image: ImageManager.icon_star, style: .plain, target: nil, action: nil)
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let contentView = UIView()
    let detailCoinInfoView = DetailCoinInfoView()
    let detailCoinInfoCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-40*ConstantsManager.standardWidth)/3, height: 34*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailCoinInfoCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCoinInfoCategoryCollectionViewCell")
        return collectionView
    }()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_98
        return view
    }()
    let toastMessage: ToastMessageView = {
        let view = ToastMessageView(message: LocalizationManager.shared.localizedString(forKey: "관심 코인에서 제외했어요"))
        view.isHidden = true
        return view
    }()
    let buttonToastMessage: ButtonToastMessageView = {
        let view = ButtonToastMessageView(message: LocalizationManager.shared.localizedString(forKey: "관심 코인에 추가했어요"), buttonTitle: LocalizationManager.shared.localizedString(forKey: "보러가기"))
        view.isHidden = true
        return view
    }()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    var innerScrollingDownDueToOuterScroll = false
    var innerScrollViewContentSize: CGFloat = 0.0
    var initialInnerScrollViewContentSize: CGFloat = 0.0
    var isSetInnerScrollViewContentSize = false
    var isSetInitialInnerScrollViewContentSize = false
    let infoViewController: InfoViewController
    private var currentToastView: UIView?
    
    init(with reactor: DetailCoinInfoReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        infoViewController = viewControllers[1] as! InfoViewController
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        scrollView.delegate = self
        infoViewController.infoView.scrollView.delegate = self
        reactor?.action.onNext(.setCoinDetailBaseInfo)
        layout()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [favoriteButton,searchButton]
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.favoritesDeleted)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.showToastMessage(self?.toastMessage ?? UIView())
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.favoritesAdded)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.showToastMessage(self?.buttonToastMessage ?? UIView())
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
    
    private func layout(){
        view.addSubview(scrollView)
        view.addSubview(toastMessage)
        view.addSubview(buttonToastMessage)
        scrollView.addSubview(contentView)
        [detailCoinInfoView,grayView,detailCoinInfoCategoryCollectionView,pageViewController.view]
            .forEach{
                contentView.addSubview($0)
            }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
        
        buttonToastMessage.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        detailCoinInfoView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        detailCoinInfoCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(detailCoinInfoView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(detailCoinInfoCategoryCollectionView.snp.bottom)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(detailCoinInfoCategoryCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(view.bounds.height - detailCoinInfoCategoryCollectionView.frame.maxY)
        }
    }
}

extension DetailCoinInfoViewController {
    func bind(reactor: DetailCoinInfoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailCoinInfoReactor){
        buttonToastMessage.toastButton.rx.tap
            .map{ Reactor.Action.toastButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .map{ Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .map{ Reactor.Action.favoriteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailCoinInfoCategoryCollectionView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailCoinInfoReactor){
        reactor.state.map { $0.selectedItem }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] index in
                let direction: UIPageViewController.NavigationDirection = (index > reactor.currentState.previousIndex) ? .forward : .reverse
                self?.pageViewController.setViewControllers([self!.viewControllers[index]], direction: direction, animated: true, completion: nil)
                self?.detailCoinInfoCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                reactor.action.onNext(.setPreviousIndex(index))
                if index == 0 {
                    self?.scrollView.contentOffset.y = 0
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isFavorites }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isFavorites in
                if isFavorites {
                    self?.favoriteButton.image = ImageManager.icon_star_select?.withRenderingMode(.alwaysOriginal)
                }
                else {
                    self?.favoriteButton.image = ImageManager.icon_star
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isPush }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isPush in
                if isPush {
                    self?.detailCoinInfoView.alarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 받는 중"), for: .normal)
                    self?.detailCoinInfoView.alarmButton.setImage(ImageManager.check20, for: .normal)
                }
                else {
                    self?.detailCoinInfoView.alarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "지정가 알림"), for: .normal)
                    self?.detailCoinInfoView.alarmButton.setImage(ImageManager.notification20, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinTitle }
            .distinctUntilChanged()
            .bind(to: detailCoinInfoView.coinTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinPrice }
            .distinctUntilChanged()
            .bind(to: detailCoinInfoView.priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.yesterdayComparisonInfo }
            .distinctUntilChanged()
            .bind(to: detailCoinInfoView.comparePriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: detailCoinInfoCategoryCollectionView.rx.items(cellIdentifier: "DetailCoinInfoCategoryCollectionViewCell", cellType: DetailCoinInfoCategoryCollectionViewCell.self)) { (index, categories, cell) in
                
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
    }
}

extension DetailCoinInfoViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            detailCoinInfoCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectItem(index))
            if visibleViewController is ChartViewController {
                self.scrollView.contentOffset.y = 0
            }
        }
    }
}

extension DetailCoinInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerScrollView = self.scrollView
        let innerScrollView = self.infoViewController.infoView.scrollView
        let outerScroll = scrollView == outerScrollView
        let innerScroll = scrollView == self.infoViewController.infoView.scrollView
        let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let lessScroll = !moreScroll
        
        let outerScrollMaxOffsetY = detailCoinInfoCategoryCollectionView.frame.origin.y - 8 * ConstantsManager.standardHeight
        
        let collectionViewBottom = detailCoinInfoCategoryCollectionView.frame.maxY
        let visibleHeight = view.frame.height - collectionViewBottom
        
        if !isSetInnerScrollViewContentSize {
            initialInnerScrollViewContentSize = innerScrollView.contentSize.height
            isSetInnerScrollViewContentSize = true
            print("Inner ScrollView Content Size 설정 완료")
        }
        
        let innerScrollMaxOffsetY = visibleHeight
        
        if !isSetInitialInnerScrollViewContentSize {
            innerScrollView.contentSize.height += detailCoinInfoView.frame.height + view.safeAreaInsets.top
            isSetInitialInnerScrollViewContentSize = true
            print("Initial Inner ScrollView Content Size 설정 완료")
        }
        
        if outerScroll && moreScroll {
            print("Outer Scroll을 더 내림")
            guard outerScrollMaxOffsetY < outerScrollView.contentOffset.y + 0.1 else {
                print("Outer Scroll이 Max Offset에 도달하지 않음")
                return
            }
            
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            guard outerScrollView.contentOffset.y < outerScrollMaxOffsetY else {
                print("Inner Scroll이 Max Offset에 도달: 고정")
                outerScrollView.contentOffset.y = outerScrollMaxOffsetY
                return
            }
            
            innerScrollView.contentOffset.y += outerScrollView.contentOffset.y - outerScrollMaxOffsetY
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
            print("Outer에서 Inner로 스크롤 전환")
        }
        
        if outerScroll && lessScroll {
            print("Outer Scroll을 덜 내림")
            guard innerScrollView.contentOffset.y > 0 && outerScrollView.contentOffset.y < outerScrollMaxOffsetY else {
                print("스크롤 조정 필요 없음")
                return
            }
            
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            innerScrollView.contentOffset.y = max(innerScrollView.contentOffset.y - (outerScrollMaxOffsetY - outerScrollView.contentOffset.y), 0)
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
            print("Inner Scroll이 동작, Outer는 고정")
        }
        
        if innerScroll && lessScroll {
            print("Inner Scroll을 덜 내림")
            if innerScrollView.contentOffset.y <= 0 {
                let overscroll = max(-innerScrollView.contentOffset.y, 0)
                if outerScrollView.contentOffset.y > 0 {
                    outerScrollView.contentOffset.y = max(outerScrollView.contentOffset.y - overscroll, 0)
                }
                innerScrollView.contentOffset.y = 0
                print("Inner가 최상단에 도달, Outer로 전환")
            }
        }
        
        if innerScroll && moreScroll {
            print("Inner Scroll을 더 내림")
            if !innerScrollingDownDueToOuterScroll {
                if outerScrollView.contentOffset.y + 0.1 < outerScrollMaxOffsetY {
                    let minOffsetY = min(outerScrollView.contentOffset.y + innerScrollView.contentOffset.y, outerScrollMaxOffsetY)
                    let offsetY = max(minOffsetY, 0)
                    outerScrollView.contentOffset.y = offsetY
                    innerScrollView.contentOffset.y = 0
                }
                else if innerScrollView.contentOffset.y + 0.1 > innerScrollMaxOffsetY {
                    innerScrollView.contentOffset.y = innerScrollMaxOffsetY
                    print("Inner Scroll이 Max Offset에 도달: 고정")
                }
            }
        }
        
    }
}
