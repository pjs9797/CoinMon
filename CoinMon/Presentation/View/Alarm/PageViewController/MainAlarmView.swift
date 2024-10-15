import UIKit
import SnapKit

class MainAlarmView: UIView {
    let alarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D3_22
        label.textColor = ColorManager.common_0
        return label
    }()
    let inquiryButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .trailing
        button.titleLabel?.font = FontManager.B3_16
        button.setTitleColor(ColorManager.gray_40, for: .normal)
        return button
    }()
    let alarmCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-40*ConstantsManager.standardWidth)/2, height: 34*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailCoinInfoCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCoinInfoCategoryCollectionViewCell")
        return collectionView
    }()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_98
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        alarmLabel.text = LocalizationManager.shared.localizedString(forKey: "코인")
        inquiryButton.setTitle(LocalizationManager.shared.localizedString(forKey: "문의2"), for: .normal)
    }
    
    private func layout() {
        [alarmLabel,inquiryButton,grayView,alarmCategoryCollectionView]
            .forEach{
                addSubview($0)
            }
        
        alarmLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20*ConstantsManager.standardHeight)
        }
        
        inquiryButton.snp.makeConstraints { make in
            make.width.equalTo(64*ConstantsManager.standardWidth)
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(alarmLabel)
        }
        
        alarmCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(alarmLabel.snp.bottom).offset(30*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(alarmCategoryCollectionView.snp.bottom)
        }
    }
}
