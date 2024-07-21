import UIKit
import SnapKit

class AlarmView: UIView {
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D3_22
        label.textColor = ColorManager.common_0
        return label
    }()
    let addAlarmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.T3_16
        button.setTitleColor(ColorManager.gray_15, for: .normal)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    let remainingAlarmCntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_15
        label.textColor = ColorManager.common_0
        return label
    }()
    let searchView = SearchView()
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8*ConstantsManager.standardWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20*ConstantsManager.standardWidth, bottom: 0, right: 20*ConstantsManager.standardWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListAtAlarmCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListAtAlarmCollectionViewCell")
        return collectionView
    }()
    let allNoneAlarmView = AllNoneAlarmView()
    let noneAlarmView = NoneAlarmView()
    let alarmTableViewHeader = AlarmTableViewHeader()
    let alarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 60*ConstantsManager.standardHeight
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")
        return tableView
    }()
    let completeDeleteAlarmToast: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_10
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.check
        return imageView
    }()
    let toastLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.common_100
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        alarmLabel.text = LocalizationManager.shared.localizedString(forKey: "지정가 알람")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "알림 받는 코인 검색"), attributes: attributes)
        addAlarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가버튼"), for: .normal)
        alarmTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        alarmTableViewHeader.setPriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "설정가 헤더",arguments: "USDT"), for: .normal)
        allNoneAlarmView.setLocalizedText()
        noneAlarmView.setLocalizedText()
        toastLabel.text = LocalizationManager.shared.localizedString(forKey: "알람 삭제 toast")
    }
    
    private func layout() {
        [alarmLabel,addAlarmButton,remainingAlarmCntLabel,searchView,marketCollectionView,alarmTableViewHeader,alarmTableView,allNoneAlarmView,noneAlarmView,completeDeleteAlarmToast]
            .forEach{
                addSubview($0)
            }
        
        [checkImageView,toastLabel]
            .forEach{
                completeDeleteAlarmToast.addSubview($0)
            }
        
        alarmLabel.snp.makeConstraints { make in
            make.height.equalTo(42*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5*ConstantsManager.standardHeight)
        }
        
        addAlarmButton.snp.makeConstraints { make in
            make.width.equalTo(60*ConstantsManager.standardWidth)
            make.height.equalTo(42*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(alarmLabel)
        }
        
        remainingAlarmCntLabel.snp.makeConstraints { make in
            make.height.equalTo(23*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(alarmLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(53*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(remainingAlarmCntLabel.snp.bottom).offset(13*ConstantsManager.standardHeight)
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        alarmTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        alarmTableView.snp.makeConstraints { make in
            make.top.equalTo(alarmTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        allNoneAlarmView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(118*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneAlarmView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(118*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        completeDeleteAlarmToast.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-24*ConstantsManager.standardHeight)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(checkImageView)
        }
    }
}
