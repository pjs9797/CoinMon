import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class DeleteIndicatorPushSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D4_20
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let subLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B4_15
        label.textColor = ColorManager.gray_15
        return label
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12*ConstantsManager.standardWidth
        return stackView
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "닫기"), for: .normal)
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.backgroundColor = ColorManager.common_100
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 삭제하기"), for: .normal)
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return button
    }()
    var heightRelay = BehaviorRelay<CGFloat>(value: 0.0)
    
    init(with reactor: DeleteIndicatorPushSheetPresentationReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        layout()
    }
    
    func layout() {
        [closeButton,deleteButton]
            .forEach{
                buttonStackView.addArrangedSubview($0)
            }
        
        [titleLabel,subLabel,buttonStackView]
            .forEach{
                view.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(subLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-32*ConstantsManager.standardHeight)
        }
    }
}

extension DeleteIndicatorPushSheetPresentationController {
    func bind(reactor: DeleteIndicatorPushSheetPresentationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DeleteIndicatorPushSheetPresentationReactor){
        closeButton.rx.tap
            .map{ Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map{ Reactor.Action.deleteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DeleteIndicatorPushSheetPresentationReactor){
        titleLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "알람을 삭제할까요?"))
        subLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "지금까지 받은 알람은 모두 삭제돼요"))
        self.view.layoutIfNeeded()
        let titleLabelHeight = self.titleLabel.intrinsicContentSize.height
        let subLabelHeight = self.subLabel.intrinsicContentSize.height
        let buttonHeight = 52*ConstantsManager.standardHeight
        let verticalMargins = (32 + 4 + 16 + 32) * ConstantsManager.standardHeight
        let totalHeight = titleLabelHeight + subLabelHeight + buttonHeight + verticalMargins

        self.heightRelay.accept(totalHeight)
    }
}
