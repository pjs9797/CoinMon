import UIKit
import SnapKit

class DetailIndicatorView: UIView {
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.font = FontManager.D8_14
        label.textColor = ColorManager.gray_40
        return label
    }()
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let settingButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = LocalizationManager.shared.localizedString(forKey: "설정")
        configuration.baseForegroundColor = ColorManager.gray_20
        configuration.baseBackgroundColor = ColorManager.common_100
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 16*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 16*ConstantsManager.standardWidth)

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = FontManager.D8_14
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let detailIndicatorTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(DetailIndicatorTableViewCell.self, forCellReuseIdentifier: "DetailIndicatorTableViewCell")
        return tableView
    }()
    let testAlarmView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let alarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.notification20?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorManager.gray_15 ?? .black
        return imageView
    }()
    let testAlarmLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "테스트 알림")
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_15
        return label
    }()
    let receiveTestAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 받기"), for: .normal)
        button.setTitleColor(ColorManager.gray_15, for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        return button
    }()
    let toastMessage: ToastMessageView = {
        let view = ToastMessageView(message: LocalizationManager.shared.localizedString(forKey: "지표 알람을 등록했어요"))
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [indicatorLabel,premiumLabel,frequencyLabel,settingButton,detailIndicatorTableView,testAlarmView,toastMessage]
            .forEach{
                addSubview($0)
            }
        
        [alarmImageView,testAlarmLabel,receiveTestAlarmButton]
            .forEach{
                testAlarmView.addSubview($0)
            }
        
        indicatorLabel.snp.makeConstraints { make in
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(indicatorLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        frequencyLabel.snp.makeConstraints { make in
            make.height.equalTo(23*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorLabel.snp.leading)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        settingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardHeight)
            make.top.equalTo(indicatorLabel.snp.top).offset(8.5*ConstantsManager.standardHeight)
        }
        
        detailIndicatorTableView.snp.makeConstraints { make in
            make.height.equalTo(500*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(frequencyLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        testAlarmView.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
        
        alarmImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        testAlarmLabel.snp.makeConstraints { make in
            make.leading.equalTo(alarmImageView.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        receiveTestAlarmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastMessage.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
    }
}
