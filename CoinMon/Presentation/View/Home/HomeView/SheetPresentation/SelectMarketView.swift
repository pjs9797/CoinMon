import UIKit
import SnapKit

class SelectMarketView: UIView {
    let selectMarketLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        label.text = LocalizationManager.shared.localizedString(forKey: "거래소 선택")
        return label
    }()
    let marketTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorStyle = .none
        tableView.rowHeight = 56*ConstantsManager.standardHeight
        tableView.register(MarketTableViewCell.self, forCellReuseIdentifier: "MarketTableViewCell")
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
        [selectMarketLabel,marketTableView]
            .forEach{
                addSubview($0)
            }
        
        selectMarketLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        marketTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(selectMarketLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
