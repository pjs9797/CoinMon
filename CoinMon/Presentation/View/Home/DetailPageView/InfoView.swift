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
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B6_13
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "코인몬에서 제공하는 정보는 고객의 투자 판단을 위한 단순 참고용일 뿐, 투자 제안 및 권유•특정 가상자산 추천을 하지 않습니다."))
        label.textColor = ColorManager.gray_70
        return label
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
        [firstInfoView,secondInfoView,thirdInfoView,noticeLabel]
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
        
        noticeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(thirdInfoView.snp.bottom).offset(52*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-232*ConstantsManager.standardHeight)
        }
    }
}
