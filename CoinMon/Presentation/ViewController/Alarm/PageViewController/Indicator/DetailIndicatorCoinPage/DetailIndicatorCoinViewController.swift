import UIKit
import ReactorKit
import SnapKit

class DetailIndicatorCoinViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let moreButton = UIBarButtonItem(image: ImageManager.icon_More_Vertical, style: .plain, target: nil, action: nil)
    let detailIndicatorCoinView = DetailIndicatorCoinView()
    let detailIndicatorCoinCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-40*ConstantsManager.standardWidth)/2, height: 34*ConstantsManager.standardHeight)
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
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: DetailIndicatorCoinReactor, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
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
        layout()
        reactor?.action.onNext(.loadIndicatorCoinHistory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.startTimer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.reactor?.action.onNext(.stopTimer)
    }
    
    private func setNavigationbar() {
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = moreButton
    }
    
    private func layout(){
        [detailIndicatorCoinView,grayView,detailIndicatorCoinCategoryCollectionView,pageViewController.view]
            .forEach{
                view.addSubview($0)
            }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        detailIndicatorCoinView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        detailIndicatorCoinCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(detailIndicatorCoinView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(detailIndicatorCoinCategoryCollectionView.snp.bottom)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(detailIndicatorCoinCategoryCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}

extension DetailIndicatorCoinViewController {
    func bind(reactor: DetailIndicatorCoinReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailIndicatorCoinReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .map{ Reactor.Action.moreButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailIndicatorCoinView.goToBinanceButton.rx.tap
            .map{ Reactor.Action.goToBinanceButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailIndicatorCoinCategoryCollectionView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailIndicatorCoinReactor){
        reactor.state.map { $0.selectedItem }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] index in
                let direction: UIPageViewController.NavigationDirection = (index > reactor.currentState.previousIndex) ? .forward : .reverse
                self?.pageViewController.setViewControllers([self!.viewControllers[index]], direction: direction, animated: true, completion: nil)
                self?.detailIndicatorCoinCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                reactor.action.onNext(.setPreviousIndex(index))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinTitle }
            .distinctUntilChanged()
            .bind(to: detailIndicatorCoinView.coinTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinPrice }
            .distinctUntilChanged()
            .bind(to: detailIndicatorCoinView.coinPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: detailIndicatorCoinCategoryCollectionView.rx.items(cellIdentifier: "DetailCoinInfoCategoryCollectionViewCell", cellType: DetailCoinInfoCategoryCollectionViewCell.self)) { (index, categories, cell) in
                
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicatorCoinHistory }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] indicatorCoinHistory in
                if let indicatorCoinHistory = indicatorCoinHistory {
                    self?.detailIndicatorCoinView.isNotEmptyHistory(indicatorCoinHistory: indicatorCoinHistory)
                }
                else {
                    self?.detailIndicatorCoinView.isEmptyHistory()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension DetailIndicatorCoinViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            detailIndicatorCoinCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectItem(index))
        }
    }
}
