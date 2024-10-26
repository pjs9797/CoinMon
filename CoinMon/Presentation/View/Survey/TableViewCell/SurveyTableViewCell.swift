import UIKit
import SnapKit

class SurveyTableViewCell: UITableViewCell {
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        self.layer.borderColor = ColorManager.gray_96?.cgColor
        self.layer.borderWidth = 1
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.layer.borderColor = isSelected ? ColorManager.orange_60?.cgColor : ColorManager.gray_96?.cgColor
        gradeLabel.textColor = isSelected ? ColorManager.orange_60 : ColorManager.common_0
        explainLabel.textColor = isSelected ? ColorManager.orange_60 : ColorManager.gray_20
    }
    
    private func layout(){
        [gradeLabel,explainLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        gradeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(12*ConstantsManager.standardHeight)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(gradeLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-12*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with arr: [String]) {
        gradeLabel.updateAttributedText(arr[0])
        explainLabel.updateAttributedText(arr[1])
    }
}
