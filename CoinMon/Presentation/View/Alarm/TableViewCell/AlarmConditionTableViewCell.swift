import UIKit
import SnapKit

class AlarmConditionTableViewCell: UITableViewCell {
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout(){
        contentView.addSubview(conditionLabel)
        
        conditionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with condition: String) {
        conditionLabel.text = condition
    }
    
    func configureTextColor(with condition: Int) {
        if condition < 0 {
            conditionLabel.textColor = .blue
        }
        else if condition == 0 {
            conditionLabel.textColor = ColorManager.common_0
        }
        else {
            conditionLabel.textColor = .red
        }
    }
}
