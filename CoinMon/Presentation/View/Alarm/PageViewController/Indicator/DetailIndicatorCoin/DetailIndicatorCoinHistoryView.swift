import UIKit
import SnapKit

class DetailIndicatorCoinHistoryView: UIView {
    let timingTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [LocalizationManager.shared.localizedString(forKey: "전체"), LocalizationManager.shared.localizedString(forKey: "매도"),LocalizationManager.shared.localizedString(forKey: "매수")])
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.H6_14,
            .foregroundColor: ColorManager.gray_60!
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.H6_14,
            .foregroundColor: ColorManager.common_0!,
            .backgroundColor: ColorManager.common_100!
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.layer.cornerRadius = 10*ConstantsManager.standardHeight
        segmentedControl.backgroundColor = ColorManager.gray_99
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_Synchronize16, for: .normal)
        button.isEnabled = false
        return button
    }()
    let refreshLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "방금 전")
        label.font = FontManager.B6_13
        label.textColor = ColorManager.gray_50
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "시간")
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_50
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "가격(USDT)")
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_50
        label.textAlignment = .right
        return label
    }()
    let timingLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "타이밍")
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_50
        label.textAlignment = .right
        return label
    }()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let indicatorHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = ColorManager.common_100
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(IndicatorHistoryTableViewCell.self, forCellReuseIdentifier: "IndicatorHistoryTableViewCell")
        return tableView
    }()
    let noneIndicatorCoinHistoryView = NoneIndicatorCoinHistoryView()
    let toastMessage: ToastMessageView = {
        let view = ToastMessageView(message: LocalizationManager.shared.localizedString(forKey: ""))
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
        [timingTypeSegmentedControl,refreshLabel,refreshButton,timeLabel,timingLabel,priceLabel,grayView,noneIndicatorCoinHistoryView,indicatorHistoryTableView,toastMessage]
            .forEach{
                addSubview($0)
            }
        
        timingTypeSegmentedControl.snp.makeConstraints { make in
            make.height.equalTo(46*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20*ConstantsManager.standardHeight)
        }
        
        refreshLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(timingTypeSegmentedControl.snp.bottom).offset(17.5*ConstantsManager.standardHeight)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(16*ConstantsManager.standardHeight)
            make.trailing.equalTo(refreshLabel.snp.leading).offset(-5*ConstantsManager.standardWidth)
            make.centerY.equalTo(refreshLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(refreshLabel.snp.bottom).offset(17.5*ConstantsManager.standardHeight)
        }
        
        timingLabel.snp.makeConstraints { make in
            make.width.equalTo(57*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(timeLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(16*ConstantsManager.standardWidth)
            make.trailing.equalTo(timingLabel.snp.leading).offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(timeLabel)
        }
        
        grayView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(timeLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        noneIndicatorCoinHistoryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(timingTypeSegmentedControl.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        indicatorHistoryTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(grayView.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
    }
    
    func isEmptyHistory() {
        refreshLabel.isHidden = true
        refreshButton.isHidden = true
        timeLabel.isHidden = true
        timingLabel.isHidden = true
        priceLabel.isHidden = true
        grayView.isHidden = true
        noneIndicatorCoinHistoryView.isHidden = false
        indicatorHistoryTableView.isHidden = true
    }
    
    func isNotEmptyHistory() {
        refreshLabel.isHidden = false
        refreshButton.isHidden = false
        timeLabel.isHidden = false
        timingLabel.isHidden = false
        priceLabel.isHidden = false
        grayView.isHidden = false
        noneIndicatorCoinHistoryView.isHidden = true
        indicatorHistoryTableView.isHidden = false
    }
}
