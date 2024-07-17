import UIKit
import SnapKit

class SelectCoinView: UIView {
    let searchView = SearchView()
    let selectCoinTableViewHeader = SelectCoinTableViewHeader()
    let selectCoinTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*ConstantsManager.standardHeight
        tableView.register(SelectCoinTableViewCell.self, forCellReuseIdentifier: "SelectCoinTableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "코인 검색"), attributes: attributes)
        selectCoinTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        selectCoinTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더",arguments: "USDT"), for: .normal)
    }
    
    private func layout() {
        [searchView,selectCoinTableViewHeader,selectCoinTableView]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        selectCoinTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
        
        selectCoinTableView.snp.makeConstraints { make in
            make.top.equalTo(selectCoinTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
