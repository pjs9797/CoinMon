import UIKit
import ReactorKit
import SnapKit

class DetailCoinInfoViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let searchButton = UIBarButtonItem(image: ImageManager.icon_search24, style: .plain, target: nil, action: nil)
    let starButton = UIBarButtonItem(image: ImageManager.icon_star, style: .plain, target: nil, action: nil)
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
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    var innerScrollingDownDueToOuterScroll = false
//    var visibleHeight: CGFloat = 0.0
    var innerScrollViewContentSize: CGFloat = 0.0
    var initialInnerScrollViewContentSize: CGFloat = 0.0
    var aa = false
    var bb = false
    
    init(with reactor: DetailCoinInfoReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let collectionViewBottom = detailCoinInfoCategoryCollectionView.frame.maxY
//        let bottomSafeArea = view.safeAreaInsets.bottom
//        visibleHeight = view.frame.height - collectionViewBottom - bottomSafeArea
//
//        print("Visible height: \(visibleHeight)")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        scrollView.delegate = self
        reactor?.action.onNext(.setCoinPrice)
        layout()
        
        if let chartViewController = viewControllers.first as? ChartViewController {
            chartViewController.chartView.scrollView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [starButton,searchButton]
    }
    
    private func layout(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [detailCoinInfoView,detailCoinInfoCategoryCollectionView,pageViewController.view]
            .forEach{
                contentView.addSubview($0)
            }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: detailCoinInfoCategoryCollectionView.rx.items(cellIdentifier: "DetailCoinInfoCategoryCollectionViewCell", cellType: DetailCoinInfoCategoryCollectionViewCell.self)) { (index, categories, cell) in
                
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.market }.distinctUntilChanged(),
            reactor.state.map { $0.coin }.distinctUntilChanged(),
            reactor.state.map { $0.priceChange }.distinctUntilChanged()
        )
        .bind(onNext: { [weak self] market,coin,priceChange in
            if let chartViewController = self?.viewControllers.first as? ChartViewController {
                chartViewController.reactor?.action.onNext(.updateData(market,coin,priceChange))
            }
        })
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
        }
    }
}

extension DetailCoinInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerScrollView = self.scrollView
        let outerScroll = scrollView == outerScrollView
        let innerScroll = !outerScroll
        let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let lessScroll = !moreScroll

        guard let chartViewController = pageViewController.viewControllers?.first as? ChartViewController else { return }
        let innerScrollView = chartViewController.chartView.scrollView
        let outerScrollMaxOffsetY = detailCoinInfoCategoryCollectionView.frame.origin.y - 8*ConstantsManager.standardHeight
        
        let collectionViewBottom = detailCoinInfoCategoryCollectionView.frame.maxY
        let visibleHeight = view.frame.height - collectionViewBottom
        
        if !aa {
            initialInnerScrollViewContentSize = innerScrollView.contentSize.height
            aa = true
        }
        
        let innerScrollMaxOffsetY = initialInnerScrollViewContentSize - visibleHeight
        
        print()
        if scrollView == outerScrollView{
            print("아우터 스크롤뷰")
        }
        else {
            print("이너 스크롤뷰")
        }
        print("outerScrollMaxOffsetY",outerScrollMaxOffsetY,"outerScrollView.contentOffset.y",outerScrollView.contentOffset.y+0.1)
        print("innerScrollMaxOffsetY",innerScrollMaxOffsetY,"innerScrollView.contentOffset.y",innerScrollView.contentOffset.y+0.1)
        if !bb {
            innerScrollView.contentSize.height += detailCoinInfoView.frame.height + view.safeAreaInsets.top
            bb = true
        }
        print("outerScrollView.contentSize.height",outerScrollView.contentSize.height)
        print("innerScrollView.contentSize.height",innerScrollView.contentSize.height)
        if outerScroll && moreScroll {
            print(1111)
            guard outerScrollMaxOffsetY < outerScrollView.contentOffset.y + 0.1 else { return }
            
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            // innerScrollView를 모두 스크롤 한 경우 stop
            guard innerScrollView.contentOffset.y < innerScrollMaxOffsetY else {
                print("멈춰")
                innerScrollView.contentOffset.y = innerScrollMaxOffsetY
                return
            }
            print("안멈춰")
            innerScrollView.contentOffset.y = innerScrollView.contentOffset.y + outerScrollView.contentOffset.y - outerScrollMaxOffsetY
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        if outerScroll && lessScroll {
            print(222)
            guard innerScrollView.contentOffset.y > 0 && outerScrollView.contentOffset.y < outerScrollMaxOffsetY else { return }
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            // outer scroll에서 스크롤한 만큼 inner scroll에 적용
            innerScrollView.contentOffset.y = max(innerScrollView.contentOffset.y - (outerScrollMaxOffsetY - outerScrollView.contentOffset.y), 0)
            
            // outer scroll은 스크롤 되지 않고 고정
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        if innerScroll && lessScroll {
            print(333)
            defer { innerScrollView.lastOffsetY = innerScrollView.contentOffset.y }
            guard innerScrollView.contentOffset.y < 0 && outerScrollView.contentOffset.y > 0 else { return }
            
            // innerScrollView의 bounces에 의하여 다시 outerScrollView가 당겨질수 있으므로 bounces로 다시 되돌아가는 offset 방지
            guard innerScrollView.lastOffsetY > innerScrollView.contentOffset.y else { return }
            
            let moveOffset = outerScrollMaxOffsetY - abs(innerScrollView.contentOffset.y) * 3
            guard moveOffset < outerScrollView.contentOffset.y else { return }
            print(moveOffset)
            
            outerScrollView.contentOffset.y = max(moveOffset, 0)
        }
        
        if innerScroll && moreScroll {
            print(4444)
            if !innerScrollingDownDueToOuterScroll{
                if outerScrollView.contentOffset.y + 0.1 < outerScrollMaxOffsetY {
                    // outer scroll를 more 스크롤
                    print("아우터 스크롤 몰 스크롤중")
                    let minOffetY = min(outerScrollView.contentOffset.y + innerScrollView.contentOffset.y, outerScrollMaxOffsetY)
                    let offsetY = max(minOffetY, 0)
                    outerScrollView.contentOffset.y = offsetY
                    
                    // inner scroll은 스크롤 되지 않아야 하므로 0으로 고정
                    innerScrollView.contentOffset.y = 0
                }
                else {
                    if innerScrollView.contentOffset.y + 0.1 < innerScrollMaxOffsetY {
                        
                        print("이너 스크롤 몰 스크롤중",innerScrollView.contentSize.height)
                    }
                    else {
                        print("이너 스크롤 맥스치")
                        innerScrollView.contentOffset.y = innerScrollMaxOffsetY
                    }
                }
            }
        }
    }
}

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}

extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
