import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class MoreButtonAtIndicatorSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let updateButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.T3_16, foregroundColor: ColorManager.common_0, backgroundColor: ColorManager.common_100)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "알람 수정")
        configuration?.image = ImageManager.icon_edit24
        configuration?.imagePadding = 12*ConstantsManager.standardWidth
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 16*ConstantsManager.standardHeight, leading: 0, bottom: 16*ConstantsManager.standardHeight, trailing: 0)
        button.configuration = configuration
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let deleteButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.T3_16, foregroundColor: ColorManager.common_0, backgroundColor: ColorManager.common_100)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "알람 삭제")
        configuration?.image = ImageManager.icon_edit24
        configuration?.imagePadding = 12*ConstantsManager.standardWidth
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 16*ConstantsManager.standardHeight, leading: 0, bottom: 16*ConstantsManager.standardHeight, trailing: 0)
        button.configuration = configuration
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    init(with reactor: MoreButtonAtIndicatorSheetPresentationReactor) {
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
        [updateButton,deleteButton]
            .forEach{
                view.addSubview($0)
            }
        
        updateButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(updateButton.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}

extension MoreButtonAtIndicatorSheetPresentationController {
    func bind(reactor: MoreButtonAtIndicatorSheetPresentationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MoreButtonAtIndicatorSheetPresentationReactor){
        updateButton.rx.tap
            .map{ Reactor.Action.updateButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map{ Reactor.Action.deleteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MoreButtonAtIndicatorSheetPresentationReactor){
    }
}
