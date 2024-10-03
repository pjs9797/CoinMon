import UIKit
import SnapKit

class PriceCategoryView: UIView {
    let marketButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D5_18
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        return button
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D5_18
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        return button
    }()
    let addButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.T5_14
        button.setTitleColor(ColorManager.gray_60, for: .normal)
        button.isHidden = true
        return button
    }()
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_96
        view.isHidden = true
        return view
    }()
    let editButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.T5_14
        button.setTitleColor(ColorManager.gray_60, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.common_100
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        marketButton.setTitle(LocalizationManager.shared.localizedString(forKey: "마켓"), for: .normal)
        favoriteButton.setTitle(LocalizationManager.shared.localizedString(forKey: "관심"), for: .normal)
        addButton.setTitle(LocalizationManager.shared.localizedString(forKey: "추가"), for: .normal)
        editButton.setTitle(LocalizationManager.shared.localizedString(forKey: "편집"), for: .normal)
    }
    
    private func layout() {
        [marketButton,favoriteButton,editButton,separateView,addButton]
            .forEach{
                addSubview($0)
            }
        
        marketButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(marketButton.snp.trailing)
            make.centerY.equalTo(marketButton)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(marketButton)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalTo(1*ConstantsManager.standardWidth)
            make.height.equalTo(16*ConstantsManager.standardHeight)
            make.trailing.equalTo(editButton.snp.leading).offset(-10*ConstantsManager.standardWidth)
            make.centerY.equalTo(marketButton)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(separateView.snp.leading).offset(-10*ConstantsManager.standardWidth)
            make.centerY.equalTo(marketButton)
        }
    }
}
