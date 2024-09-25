import UIKit
import SnapKit

class SearchView: UIView {
    let searchBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.search
        return imageView
    }()
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.T4_15
        textField.keyboardType = .asciiCapable
        return textField
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.iconClear, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(searchBar)
        [searchImageView,searchTextField,clearButton]
            .forEach{
                searchBar.addSubview($0)
            }
        
        searchBar.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(43*ConstantsManager.standardHeight)
            make.center.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16.67*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-12*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalTo(searchTextField.snp.trailing)
            make.centerY.equalTo(searchTextField)
        }
    }
}
