import UIKit
import SnapKit

class PurchaseView: UIView {
    let imageView1: UIImageView = {
        let imageView = UIImageView()
        if LocalizationManager.shared.language == "ko" {
            imageView.image = ImageManager.tryNewIndicator_ko
        }
        else {
            imageView.image = ImageManager.tryNewIndicator_en
        }
        imageView.layer.cornerRadius = 20*ConstantsManager.standardHeight
        return imageView
    }()
    let purchaseButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), for: .normal)
        return button
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [imageView1,purchaseButton,activityIndicator]
            .forEach{
                addSubview($0)
            }

        imageView1.snp.makeConstraints { make in
            make.height.equalTo(524*ConstantsManager.standardHeight)
            make.leading.trailing.top.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
