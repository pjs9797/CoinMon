import UIKit
import SnapKit

class SearchView: UIView {
    let searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*Constants.standardHeight
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
        addSubview(searchView)
        [searchImageView,searchTextField,clearButton]
            .forEach{
                searchView.addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(43*Constants.standardHeight)
            make.center.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16.67*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(20*Constants.standardHeight)
            make.trailing.equalTo(searchTextField.snp.trailing)
            make.centerY.equalTo(searchTextField)
        }
    }
}
