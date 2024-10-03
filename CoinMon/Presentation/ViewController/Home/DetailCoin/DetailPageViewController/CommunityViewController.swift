import UIKit
import SnapKit

class CommunityViewController: UIViewController {
    let updatelabel: UILabel = {
        let label = UILabel()
        label.text = "업데이트 예정"
        label.font = FontManager.B1_20
        label.textColor = ColorManager.common_0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        view.addSubview(updatelabel)
        updatelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
    }
}
