import UIKit
import SnapKit

class SurveyView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D3_22
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "어떤 투자 경험을 가지고 계신가요?"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B3_16
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "좀 더 나은 서비스를 만들기 위해 쓰여요"))
        label.textColor = ColorManager.gray_60
        return label
    }()
    let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: "SurveyTableViewCell")
        return tableView
    }()
    let completeButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "완료"), for: .normal)
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
        [titleLabel,subTitleLabel,surveyTableView,completeButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60*ConstantsManager.standardHeight)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.top).offset(8*ConstantsManager.standardHeight)
        }
        
        surveyTableView.snp.makeConstraints { make in
            make.height.equalTo(450*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(subTitleLabel.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
