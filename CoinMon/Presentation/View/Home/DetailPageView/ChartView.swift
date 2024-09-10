import UIKit
import WebKit
import SnapKit

class ChartView: UIView {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let contentView = UIView()
    let chartWebView = WKWebView()
    let firstSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "시세 변동")
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let priceChangeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8*ConstantsManager.standardHeight, left: 4*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, right: 4*ConstantsManager.standardWidth)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-44*ConstantsManager.standardWidth)/5, height: 46*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.gray_99
        collectionView.layer.cornerRadius = 8*ConstantsManager.standardHeight
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PriceChangeCollectionViewCell.self, forCellWithReuseIdentifier: "PriceChangeCollectionViewCell")
        return collectionView
    }()
    let secondSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let viewInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "종목 정보 보기"), for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.gray_30, for: .normal)
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4*ConstantsManager.standardWidth, bottom: 0, right: 4*ConstantsManager.standardWidth)
        return button
    }()
    let receiveNotiButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "지정가 알림 받기"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [chartWebView,firstSeparateView,priceChangeLabel,priceChangeCollectionView,secondSeparateView,viewInfoButton,receiveNotiButton]
            .forEach{
                contentView.addSubview($0)
            }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        chartWebView.snp.makeConstraints { make in
            make.height.equalTo(596*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        firstSeparateView.snp.makeConstraints { make in
            make.height.equalTo(8*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(chartWebView.snp.bottom)
        }
        
        priceChangeLabel.snp.makeConstraints { make in
            make.height.equalTo(26*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(firstSeparateView.snp.bottom).offset(48*ConstantsManager.standardHeight)
        }
        
        priceChangeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(62*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(priceChangeLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        secondSeparateView.snp.makeConstraints { make in
            make.height.equalTo(1*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceChangeCollectionView.snp.bottom).offset(48*ConstantsManager.standardHeight)
        }
        
        viewInfoButton.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalTo(38*ConstantsManager.standardWidth)
            make.trailing.equalTo(-38*ConstantsManager.standardWidth)
            make.top.equalTo(secondSeparateView.snp.bottom).offset(29*ConstantsManager.standardHeight)
        }
        
        receiveNotiButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(viewInfoButton.snp.bottom).offset(36*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
    }
}
