//import UIKit
//import SnapKit
//
//class AddAlarmView: UIView {
//    let marketLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontManager.H6_14
//        label.textColor = ColorManager.common_0
//        return label
//    }()
//    let coinLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontManager.H6_14
//        label.textColor = ColorManager.common_0
//        return label
//    }()
//    let currentPriceLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontManager.H6_14
//        label.textColor = ColorManager.common_0
//        return label
//    }()
//    let setPriceLabel: UILabel = {
//        let label = UILabel()
//        label.font = FontManager.H6_14
//        label.textColor = ColorManager.common_0
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        layout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setLocalizedText(){
//        alarmLabel.text = LocalizationManager.shared.localizedString(forKey: "지정가 알람")
//        searchView.searchTextField.placeholder = LocalizationManager.shared.localizedString(forKey: "코인 검색")
//        addAlarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가버튼"), for: .normal)
//        alarmTableViewHeader.setPriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "설정가/현재가"), for: .normal)
//    }
//    
//    private func layout() {
//        [alarmLabel,addAlarmButton,marketCollectionView,searchView,noneAlarmView,alarmTableViewHeader,alarmTableView]
//            .forEach{
//                addSubview($0)
//            }
//        
//        alarmLabel.snp.makeConstraints { make in
//            make.height.equalTo(42*Constants.standardHeight)
//            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
//            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
//            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5*Constants.standardHeight)
//        }
//        
//        addAlarmButton.snp.makeConstraints { make in
//            make.width.equalTo(60*Constants.standardWidth)
//            make.height.equalTo(42*Constants.standardHeight)
//            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
//            make.centerY.equalTo(alarmLabel)
//        }
//        
//        marketCollectionView.snp.makeConstraints { make in
//            make.width.equalTo(355*Constants.standardWidth)
//            make.height.equalTo(35*Constants.standardHeight)
//            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
//            make.top.equalTo(alarmLabel.snp.bottom).offset(5*Constants.standardHeight)
//        }
//        
//        searchView.snp.makeConstraints { make in
//            make.height.equalTo(59*Constants.standardHeight)
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*Constants.standardHeight)
//        }
//        
//        noneAlarmView.snp.makeConstraints { make in
//            make.width.equalTo(335*Constants.standardWidth)
//            make.height.equalTo(146*Constants.standardHeight)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(searchView.snp.bottom).offset(100*Constants.standardHeight)
//        }
//        
//        alarmTableViewHeader.snp.makeConstraints { make in
//            make.height.equalTo(32*Constants.standardHeight)
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(searchView.snp.bottom)
//        }
//        
//        alarmTableView.snp.makeConstraints { make in
//            make.top.equalTo(alarmTableViewHeader.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
//        }
//    }
//}
