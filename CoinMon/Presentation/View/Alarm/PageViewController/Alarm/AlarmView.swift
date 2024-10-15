import UIKit
import SnapKit

class AlarmView: UIView {
    let addAlarmButtonTapGesture = UITapGestureRecognizer()
    let addAlarmButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8*ConstantsManager.standardHeight
        view.layer.borderColor = ColorManager.gray_96?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let addAlarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.gray_20
        return label
    }()
    let cntAlarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.gray_60
        return label
    }()
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
        imageView.image = ImageManager.check24
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
        
        addAlarmButtonView.addGestureRecognizer(addAlarmButtonTapGesture)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        addAlarmLabel.text = LocalizationManager.shared.localizedString(forKey: "알람 추가")
        alarmTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        alarmTableViewHeader.setPriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "설정가 헤더",arguments: "USDT"), for: .normal)
        noneAlarmView.setLocalizedText()
        toastLabel.text = LocalizationManager.shared.localizedString(forKey: "알람 삭제 toast")
    }
    
    private func layout() {
        [addAlarmButtonView,marketCollectionView,alarmTableViewHeader,alarmTableView,noneAlarmView,completeDeleteAlarmToast]
            .forEach{
                addSubview($0)
            }
        
        [addAlarmLabel,cntAlarmLabel]
            .forEach{
                addAlarmButtonView.addSubview($0)
            }
        
        [checkImageView,toastLabel]
            .forEach{
                completeDeleteAlarmToast.addSubview($0)
            }
        
        addAlarmButtonView.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        addAlarmLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(116*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        cntAlarmLabel.snp.makeConstraints { make in
            make.leading.equalTo(addAlarmLabel.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(addAlarmButtonView.snp.bottom).offset(16*ConstantsManager.standardHeight)
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
