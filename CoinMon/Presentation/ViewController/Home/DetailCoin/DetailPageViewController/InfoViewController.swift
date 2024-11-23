import UIKit
import ReactorKit
import Kingfisher

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
        reactor?.action.onNext(.setCoinDetailPriceInfo)
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
        reactor.state.map{ $0.coin }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] coin in
                let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
                if let imageURL = URL(string: "\(baseURL)\(coin).png") {
                    self?.infoView.firstInfoView.coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
                } else {
                    self?.infoView.firstInfoView.coinImageView.image = ImageManager.login_coinmon
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinTitle }
            .distinctUntilChanged()
            .bind(to: infoView.firstInfoView.coinTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.highPrice }
            .distinctUntilChanged()
            .bind(to: infoView.secondInfoView.highPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.lowPrice }
            .distinctUntilChanged()
            .bind(to: infoView.secondInfoView.lowPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.priceChangeList }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: infoView.thirdInfoView.priceChangeCollectionView.rx.items(cellIdentifier: "PriceChangeCollectionViewCell", cellType: PriceChangeCollectionViewCell.self)) { index, data, cell in
                
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)
    }
}
