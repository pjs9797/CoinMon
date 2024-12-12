import UIKit
import SnapKit
import RxSwift

class SurveyTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let surveyView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.layer.borderColor = ColorManager.gray_96?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = ColorManager.common_100
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func isSelect(isSelected: Bool) {
        surveyView.layer.borderColor = isSelected ? ColorManager.orange_60?.cgColor : ColorManager.gray_96?.cgColor
        gradeLabel.textColor = isSelected ? ColorManager.orange_60 : ColorManager.common_0
        explainLabel.textColor = isSelected ? ColorManager.orange_60 : ColorManager.gray_20
    }
    
    private func layout(){
        contentView.addSubview(surveyView)
        
        [gradeLabel,explainLabel]
            .forEach {
                surveyView.addSubview($0)
            }
        
        surveyView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12*ConstantsManager.standardHeight)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(12*ConstantsManager.standardHeight)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(gradeLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-12*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with arr: [String]) {
        gradeLabel.updateAttributedText(arr[0])
        explainLabel.updateAttributedText(arr[1])
    }
}
