import UIKit
import SnapKit

class UpdateIndicatorCoinView: UIView {
    let indicatorCoinCntLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let selectButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.D8_14, foregroundColor: ColorManager.gray_20, backgroundColor: ColorManager.common_100)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "선택")
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 16*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 16*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let updateIndicatorCoinTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UpdateIndicatorCoinTableViewCell.self, forCellReuseIdentifier: "UpdateIndicatorCoinTableViewCell")
        return tableView
    }()
    let saveButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "저장"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [indicatorCoinCntLabel,selectButton,updateIndicatorCoinTableView,saveButton]
            .forEach{
                addSubview($0)
            }
        
        indicatorCoinCntLabel.snp.makeConstraints { make in
            make.height.equalTo(38*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorCoinCntLabel)
        }
        
        updateIndicatorCoinTableView.snp.makeConstraints { make in
            make.height.equalTo(200*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorCoinCntLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
