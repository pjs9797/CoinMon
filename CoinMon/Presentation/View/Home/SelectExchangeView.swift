import UIKit
import SnapKit

class SelectExchangeView: UIView {
    let selectExchangeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let exchangeTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 56*Constants.standardHeight
        tableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: "ExchangeTableViewCell")
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
        [selectExchangeLabel,exchangeTableView]
            .forEach{
                addSubview($0)
            }
        
        selectExchangeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalToSuperview().offset(32*Constants.standardHeight)
        }
        
        exchangeTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(selectExchangeLabel.snp.bottom).offset(12*Constants.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
