import UIKit
import ReactorKit

class InfoViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let infoView = InfoView()
    
    init(with reactor: InfoReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = infoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.gray_99
    }
}

extension InfoViewController {
    func bind(reactor: InfoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: InfoReactor){
        
    }
    
    func bindState(reactor: InfoReactor){
        reactor.state.map { $0.priceChangeList }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: infoView.thirdInfoView.priceChangeCollectionView.rx.items(cellIdentifier: "PriceChangeCollectionViewCell", cellType: PriceChangeCollectionViewCell.self)) { index, data, cell in
                
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)
    }
}
