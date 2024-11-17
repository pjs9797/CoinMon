import RxFlow

enum SigninStep: Step, StepProtocol {
    //MARK: 푸시
    case navigateToSigninEmailEntryViewController
    case navigateToSigninEmailVerificationNumberViewController
    
    //MARK: 프레젠트
    case presentToAuthenticationNumberErrorAlertController
    case presentToNoRegisteredEmailErrorAlertController
    
    //MARK: 뒤로가기
    case popViewController
    case popToRootViewController
    
    //MARK: 플로우 종료
    case completeSigninFlow
    
    //MARK: 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToAWSServerErrorAlertController
}
