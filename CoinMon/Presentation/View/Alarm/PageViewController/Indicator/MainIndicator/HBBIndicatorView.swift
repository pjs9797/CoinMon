import UIKit
import SnapKit

class HBBIndicatorView: UIView {
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_questionMark18, for: .normal)
        return button
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.textColor = ColorManager.gray_40
        label.font = FontManager.D8_14
        return label
    }()
    let explainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let noticeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.orange_99
        return view
    }()
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.H6_14
        label.textColor = ColorManager.gray_15
        return label
    }()
    let indicatorAlarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(IndicatorAlarmTableViewCell.self, forCellReuseIdentifier: "IndicatorAlarmTableViewCell")
        return tableView
    }()
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let selectOtherCoinButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "다른 코인 선택하기"), for: .normal)
        button.setTitleColor(ColorManager.gray_60, for: .normal)
        button.titleLabel?.font = FontManager.T5_14
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.common_100
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [indicatorLabel,explainButton,premiumLabel,explainLabel,noticeView,indicatorAlarmTableView,separateView,selectOtherCoinButton]
            .forEach{
                addSubview($0)
            }
        
        noticeView.addSubview(noticeLabel)
        
        indicatorLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(117*ConstantsManager.standardWidth)
            make.height.greaterThanOrEqualTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.height.width.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorLabel.snp.trailing).offset(3*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-28*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalTo(indicatorLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(3*ConstantsManager.standardHeight)
        }
        
        noticeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(8*ConstantsManager.standardHeight)
        }
        
        indicatorAlarmTableView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(150*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(noticeView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorAlarmTableView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        selectOtherCoinButton.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight).priority(.high)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
