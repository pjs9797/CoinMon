import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class ExplainIndicatorSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B4_15
        label.textColor = ColorManager.gray_15
        label.numberOfLines = 0
        return label
    }()
    let okButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "확인"), for: .normal)
        button.isEnable()
        return button
    }()
    var heightRelay = BehaviorRelay<CGFloat>(value: 0.0)
    
    init(with reactor: ExplainIndicatorSheetPresentationReactor) {
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
        [indicatorLabel,explainLabel,okButton]
            .forEach{
                view.addSubview($0)
            }
        
        indicatorLabel.snp.makeConstraints { make in
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        okButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16*ConstantsManager.standardHeight)
        }
    }
}

extension ExplainIndicatorSheetPresentationController {
    
    func bind(reactor: ExplainIndicatorSheetPresentationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ExplainIndicatorSheetPresentationReactor){
        okButton.rx.tap
            .map{ Reactor.Action.okButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: ExplainIndicatorSheetPresentationReactor){
        let indicatorTextObservable = reactor.state.map { $0.indicatorLabelText }.distinctUntilChanged()
        let explainTextObservable = reactor.state.map { $0.explainLabelText }.distinctUntilChanged()

        Observable.zip(indicatorTextObservable, explainTextObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indicatorText, explainText in
                self?.indicatorLabel.updateAttributedText(indicatorText)
                self?.explainLabel.updateAttributedText(explainText)

                // 모든 텍스트가 업데이트된 후 레이아웃을 강제 적용
                self?.view.layoutIfNeeded()
                
                // 각 서브뷰의 크기 기반으로 높이 계산
                let indicatorLabelHeight = self?.indicatorLabel.intrinsicContentSize.height ?? 30.0
                let explainLabelHeight = self?.explainLabel.intrinsicContentSize.height ?? 500.0
                let buttonHeight = self?.okButton.intrinsicContentSize.height ?? 52.0
                let verticalMargins = (32 + 16 + 16 + 16 + 34) * ConstantsManager.standardHeight

                let totalHeight = indicatorLabelHeight + explainLabelHeight + buttonHeight + verticalMargins

                self?.heightRelay.accept(totalHeight)
            })
            .disposed(by: disposeBag)

    }
}
