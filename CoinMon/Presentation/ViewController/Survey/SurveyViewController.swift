import UIKit
import ReactorKit

class SurveyViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let surveyView = SurveyView()
    
    init(with reactor: SurveyReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = surveyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension SurveyViewController {
    func bind(reactor: SurveyReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SurveyReactor) {
        surveyView.completeButton.rx.tap
            .map{ Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        surveyView.surveyTableView.rx.itemSelected
            .map{ Reactor.Action.selectItem(index: $0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SurveyReactor) {
        reactor.state.map { $0.surveyItems }
            .distinctUntilChanged()
            .bind(to: surveyView.surveyTableView.rx.items(cellIdentifier: "SurveyTableViewCell", cellType: SurveyTableViewCell.self)){ row, items, cell in
                
                cell.configure(with: items)
                
                reactor.state.map { $0.selectedIndex }
                    .distinctUntilChanged()
                    .bind(onNext: { selectedIndex in
                        let isSelected = row == selectedIndex
                        cell.isSelect(isSelected: isSelected)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
