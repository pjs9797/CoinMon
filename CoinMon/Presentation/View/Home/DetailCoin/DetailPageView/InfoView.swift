import UIKit
import SnapKit

class InfoView: UIView {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let contentView = UIView()
    let firstInfoView = FirstInfoView()
    let secondInfoView = SecondInfoView()
    let thirdInfoView = ThirdInfoView()
    let noticeTextView: BaseTextView = {
        let textView = BaseTextView()
        textView.setStyle(
            text: LocalizationManager.shared.localizedString(forKey: "코인몬에서 제공하는 정보는 고객의 투자 판단을 위한 단순 참고용일 뿐, 투자 제안 및 권유•특정 가상자산 추천을 하지 않습니다."),
            style: FontManagerA.B6_13
        )
        textView.addLinks(
            links: [
                "트레이딩뷰": URL(string: "https://kr.tradingview.com/")!,
                "이코노믹 캘린더": URL(string: "https://kr.tradingview.com/economic-calendar/")!,
                "스탁 스크리너": URL(string: "https://kr.tradingview.com/screener/")!
            ],
            linkColor: ColorManager.gray_50,
            defaultColor: ColorManager.gray_70
        )
        textView.backgroundColor = ColorManager.gray_99
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.gray_99
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [firstInfoView,secondInfoView,thirdInfoView,noticeTextView]
            .forEach{
                contentView.addSubview($0)
            }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        firstInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        secondInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(firstInfoView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        thirdInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(secondInfoView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        noticeTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(thirdInfoView.snp.bottom).offset(52*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-202*ConstantsManager.standardHeight)
        }
    }
}
