import UIKit
import ReactorKit
import SnapKit

class HomeViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let homeCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCategoryCollectionViewCell")
        return collectionView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        pageViewController.dataSource = self
        pageViewController.delegate = self
        layout()
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedCategories)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout(){
        view.addSubview(homeCategoryCollectionView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        homeCategoryCollectionView.snp.makeConstraints { make in
            make.width.equalTo(355*Constants.standardWidth)
            make.height.equalTo(42*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7*Constants.standardHeight)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(homeCategoryCollectionView.snp.bottom).offset(3*Constants.standardHeight)
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
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.categories[index]) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.D3_22
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 42*Constants.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+12)*Constants.standardWidth, height: 42*Constants.standardHeight)
    }
}
