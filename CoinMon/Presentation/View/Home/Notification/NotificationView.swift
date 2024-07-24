import UIKit
import SnapKit

class NotificationView: UIView {
    let setAlarmView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.orange_99
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let cautionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.caution
        return imageView
    }()
    let setAlarmLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.gray_15
        label.font = FontManager.T5_14
        label.numberOfLines = 0
        return label
    }()
    let setAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_15, for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        return button
    }()
    let notificationTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationTableViewCell")
        return tableView
    }()
    let upButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.chevron_Up, for: .normal)
        button.layer.cornerRadius = 22*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        button.isHidden = true
        return button
    }()
    let noneNotificationView = NoneNotificationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        let footerView = NotificationTableViewFooter()
        footerView.frame.size.height = 98 * ConstantsManager.standardHeight
        notificationTableView.tableFooterView = footerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        setAlarmLabel.text = LocalizationManager.shared.localizedString(forKey: "휴대폰 앱 알림이 꺼져있어요")
        setAlarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 켜기"), for: .normal)
        noneNotificationView.noneNotificationLabel.text = LocalizationManager.shared.localizedString(forKey: "아직 새로운 알림이 없어요")
    }
    
    private func layout() {
        [setAlarmView,notificationTableView,upButton,noneNotificationView]
            .forEach{
                addSubview($0)
            }
        
        [cautionImageView,setAlarmButton,setAlarmLabel]
            .forEach {
                setAlarmView.addSubview($0)
            }
                
        cautionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(17*ConstantsManager.standardHeight)
        }
        
        setAlarmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(cautionImageView)
        }
        
        setAlarmLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(22*ConstantsManager.standardHeight)
            make.leading.equalTo(cautionImageView.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.trailing.equalTo(setAlarmButton.snp.leading).offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        setAlarmView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8*ConstantsManager.standardHeight)
        }
        
        notificationTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(setAlarmView.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        upButton.snp.makeConstraints { make in
            make.width.height.equalTo(44*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
        
        noneNotificationView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(250*ConstantsManager.standardHeight)
        }
    }
    
    func updateLayoutNotSetAlarm(){
        notificationTableView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(setAlarmView.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func updateLayoutSetAlarm(){
        notificationTableView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
