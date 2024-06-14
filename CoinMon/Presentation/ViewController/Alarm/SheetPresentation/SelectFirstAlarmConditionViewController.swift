import UIKit
import ReactorKit

class SelectFirstAlarmConditionViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectAlarmConditionView = SelectAlarmConditionView()
    
    init(with reactor: SelectFirstAlarmConditionReactor) {
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
        
        view.backgroundColor = .white
        selectAlarmConditionView.alarmConditionTableView.goToMiddle()
    }
}

extension SelectFirstAlarmConditionViewController {
    func bind(reactor: SelectFirstAlarmConditionReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectFirstAlarmConditionReactor){
        selectAlarmConditionView.alarmConditionTableView.rx.itemSelected
            .map { Reactor.Action.selectCondition($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectFirstAlarmConditionReactor){
        reactor.state.map { $0.conditions }
            .distinctUntilChanged()
            .bind(to: selectAlarmConditionView.alarmConditionTableView.rx.items(cellIdentifier: "AlarmConditionTableViewCell", cellType: AlarmConditionTableViewCell.self)){ row, condition, cell in
                let conditionToString = "\(condition)%"
                cell.configure(with: conditionToString)
                cell.configureTextColor(with: condition)
            }
            .disposed(by: disposeBag)
    }
}
