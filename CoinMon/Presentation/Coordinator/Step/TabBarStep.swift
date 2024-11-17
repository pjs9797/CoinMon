import RxFlow

enum TabBarStep: Step {
    //MARK: 푸시
    case navigateToTryNewIndicatorViewController
    
    //MARK: 프레젠트
    case presentToNewIndicatorViewController
    case presentToExplainIndicatorSheetPresentationController(indicatorId: String)
    
    //MARK: 뒤로가기
    case dismiss
    case popDownWithAnimation
    
    //MARK: 플로우 이동
    case goToPurchaseFlow
}
