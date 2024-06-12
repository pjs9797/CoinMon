import UIKit
import SnapKit

class SelectAlarmConditionView: UIView {
    let selectAlarmConditionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "조건을 선택하세요.")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let alarmConditionTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 56*Constants.standardHeight
        tableView.register(AlarmConditionTableViewCell.self, forCellReuseIdentifier: "AlarmConditionTableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [selectAlarmConditionLabel,alarmConditionTableView]
            .forEach{
                addSubview($0)
            }
        
        selectAlarmConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalToSuperview().offset(32*Constants.standardHeight)
        }
        
        alarmConditionTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(selectAlarmConditionLabel.snp.bottom).offset(12*Constants.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
