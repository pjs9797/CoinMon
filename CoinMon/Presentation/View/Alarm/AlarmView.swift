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
        return button
    }()
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListCollectionViewCell")
        return collectionView
    }()
    let searchView = SearchView()
    let noneAlarmView = NoneAlarmView()
    let alarmTableViewHeader = AlarmTableViewHeader()
    let alarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 60*Constants.standardHeight
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")
        return tableView
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
        searchView.searchTextField.placeholder = LocalizationManager.shared.localizedString(forKey: "코인 검색")
        addAlarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가버튼"), for: .normal)
        alarmTableViewHeader.setPriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "설정가 헤더",arguments: "USDT"), for: .normal)
        noneAlarmView.noneAlarmLabel.text = LocalizationManager.shared.localizedString(forKey: "알림 없음")
    }
    
    private func layout() {
        [alarmLabel,addAlarmButton,marketCollectionView,searchView,alarmTableViewHeader,alarmTableView,noneAlarmView]
            .forEach{
                addSubview($0)
            }
        
        alarmLabel.snp.makeConstraints { make in
            make.height.equalTo(42*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5*Constants.standardHeight)
        }
        
        addAlarmButton.snp.makeConstraints { make in
            make.width.equalTo(60*Constants.standardWidth)
            make.height.equalTo(42*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(alarmLabel)
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.width.equalTo(355*Constants.standardWidth)
            make.height.equalTo(35*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(alarmLabel.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        alarmTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
        
        alarmTableView.snp.makeConstraints { make in
            make.top.equalTo(alarmTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneAlarmView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*Constants.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
