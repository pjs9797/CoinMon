import UIKit
import SnapKit

class LaunchView: UIView {
    let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(splashImageView)

        splashImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
