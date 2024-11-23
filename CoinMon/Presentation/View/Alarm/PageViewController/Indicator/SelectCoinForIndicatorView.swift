import UIKit
import SnapKit

class SelectCoinForIndicatorView: UIView {
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_30
        return label
    }()
    let explainButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_questionMark18, for: .normal)
        return button
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.font = FontManager.D8_14
        label.textColor = ColorManager.gray_40
        return label
    }()
    let selectLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "알림받을 코인 최대 3개 선택해 주세요")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let searchView = SearchView()
    let binanceLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "바이낸스 거래소 기준")
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_80
        return label
    }()
    let coinForIndicatorTableViewHeader = CoinForIndicatorTableViewHeader()
    let coinForIndicatorTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 48*ConstantsManager.standardHeight
        tableView.register(CoinForIndicatorTableViewCell.self, forCellReuseIdentifier: "CoinForIndicatorTableViewCell")
        return tableView
    }()
    let noneCoinView = NoneCoinView()
    let selectedCoinForIndicatorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8*ConstantsManager.standardHeight
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.register(SelectedCoinForIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: "SelectedCoinForIndicatorCollectionViewCell")
        return collectionView
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12*ConstantsManager.standardWidth
        stackView.isHidden = true
        return stackView
    }()
    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "초기화"), for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.backgroundColor = ColorManager.common_100
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        return button
    }()
    let selectedButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "선택 완료"), for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return button
    }()
    let toastMessage = ToastMessageView(message: LocalizationManager.shared.localizedString(forKey: "코인은 최대 3개 선택 할 수 있어요"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        setLocalizedText()
        toastMessage.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "코인 검색"), attributes: attributes)
        coinForIndicatorTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        coinForIndicatorTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더",arguments: "USDT"), for: .normal)
        coinForIndicatorTableViewHeader.changeButton.setTitle(LocalizationManager.shared.localizedString(forKey: "등락률"), for: .normal)
        noneCoinView.setLocalizedText()
    }
    
    private func layout() {
        [indicatorLabel,explainButton,premiumLabel,selectLabel,searchView,binanceLabel,coinForIndicatorTableViewHeader,coinForIndicatorTableView,noneCoinView,buttonStackView,selectedCoinForIndicatorCollectionView,toastMessage]
            .forEach{
                addSubview($0)
            }
        
        [resetButton,selectedButton]
            .forEach{
                buttonStackView.addArrangedSubview($0)
            }
        
        indicatorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        selectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(45*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(selectLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        binanceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(searchView.snp.bottom).offset(14*ConstantsManager.standardHeight)
        }
        
        coinForIndicatorTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(binanceLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        coinForIndicatorTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(coinForIndicatorTableViewHeader.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneCoinView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinForIndicatorTableViewHeader.snp.bottom).offset(120*ConstantsManager.standardHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
        
        selectedCoinForIndicatorCollectionView.snp.makeConstraints { make in
            make.height.equalTo(46*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-8*ConstantsManager.standardHeight)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.height.equalTo(46*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(501*ConstantsManager.standardHeight)
        }
    }
    
    func updateUIForSelectedCoins(isEmpty: Bool) {
        buttonStackView.isHidden = isEmpty
        selectedCoinForIndicatorCollectionView.isHidden = isEmpty

        if !isEmpty {
            coinForIndicatorTableView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
                make.top.equalTo(coinForIndicatorTableViewHeader.snp.bottom)
                make.bottom.equalTo(selectedCoinForIndicatorCollectionView.snp.top)
            }
        } 
        else {
            coinForIndicatorTableView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
                make.top.equalTo(coinForIndicatorTableViewHeader.snp.bottom)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
