import UIKit
import ReactorKit
import SnapKit

class MainAlarmViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let mainAlarmView = MainAlarmView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController]
    
    init(with reactor: MainAlarmReactor, viewControllers: [UIViewController]) {
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
        pageViewController.dataSource = self
        pageViewController.delegate = self
        layout()
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.mainAlarmView.setLocalizedText()
                self?.reactor?.action.onNext(.updateLocalizedCategories)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.mainAlarmView.alarmCategoryCollectionView.selectItem(at: IndexPath(item: reactor?.currentState.selectedItem ?? 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func layout(){
        view.addSubview(mainAlarmView)
        view.addSubview(pageViewController.view)
        
        mainAlarmView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainAlarmView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainAlarmViewController {
    func bind(reactor: MainAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MainAlarmReactor){
        mainAlarmView.alarmCategoryCollectionView.rx.itemSelected
            .map { Reactor.Action.selectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainAlarmView.inquiryButton.rx.tap
            .map{ Reactor.Action.inquiryButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MainAlarmReactor){
        reactor.state.map { $0.selectedItem }
            .observe(on:MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                let direction: UIPageViewController.NavigationDirection = (index > reactor.currentState.previousIndex) ? .forward : .reverse
                self?.pageViewController.setViewControllers([self!.viewControllers[index]], direction: direction, animated: true, completion: nil)
                self?.mainAlarmView.alarmCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                reactor.action.onNext(.setPreviousIndex(index))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: mainAlarmView.alarmCategoryCollectionView.rx.items(cellIdentifier: "DetailCoinInfoCategoryCollectionViewCell", cellType: DetailCoinInfoCategoryCollectionViewCell.self)) { (index, categories, cell) in
                
                cell.categoryLabel.text = categories
            }
            .disposed(by: disposeBag)
    }
}

extension MainAlarmViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            mainAlarmView.alarmCategoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            reactor?.action.onNext(.setPreviousIndex(index))
            reactor?.action.onNext(.selectItem(index))
        }
    }
}
