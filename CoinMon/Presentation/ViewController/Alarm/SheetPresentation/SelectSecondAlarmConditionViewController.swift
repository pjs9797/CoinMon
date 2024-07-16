import UIKit
import ReactorKit

class SelectSecondAlarmConditionViewController: CustomDimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectAlarmConditionView = SelectAlarmConditionView()
    
    init(with reactor: SelectSecondAlarmConditionReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectAlarmConditionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}

extension SelectSecondAlarmConditionViewController {
    func bind(reactor: SelectSecondAlarmConditionReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectSecondAlarmConditionReactor){
        selectAlarmConditionView.alarmConditionTableView.rx.itemSelected
            .map { Reactor.Action.selectCondition($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectSecondAlarmConditionReactor){
        reactor.state.map { $0.conditions }
            .distinctUntilChanged()
            .bind(to: selectAlarmConditionView.alarmConditionTableView.rx.items(cellIdentifier: "AlarmConditionTableViewCell", cellType: AlarmConditionTableViewCell.self)){ row, condition, cell in

                cell.configure(with: condition)
            }
            .disposed(by: disposeBag)
    }
}
