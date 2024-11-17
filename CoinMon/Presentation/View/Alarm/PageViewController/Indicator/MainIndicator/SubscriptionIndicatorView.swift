import UIKit
import SnapKit

class SubscriptionIndicatorView: UIView {
    let addIndicatorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D6_16
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        button.backgroundColor = ColorManager.common_100
        return button
    }()
    let binanceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_80
        return label
    }()
    let indicatorTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = ColorManager.gray_99
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(NotSubscriptionIndicatorTableViewCell.self, forCellReuseIdentifier: "NotSubscriptionIndicatorTableViewCell")
        tableView.register(IndicatorTableViewCell.self, forCellReuseIdentifier: "IndicatorTableViewCell")
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
        addIndicatorButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가"), for: .normal)
        binanceLabel.text = LocalizationManager.shared.localizedString(forKey: "바이낸스 거래소 기준")
    }
    
    private func layout() {
        [addIndicatorButton,binanceLabel,indicatorTableView]
            .forEach{
                addSubview($0)
            }
        
        addIndicatorButton.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        binanceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(addIndicatorButton.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        indicatorTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(binanceLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
