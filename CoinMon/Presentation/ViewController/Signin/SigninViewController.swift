import UIKit
import AuthenticationServices
import ReactorKit

class SigninViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let signinView = SigninView()
    
    init(with reactor: SigninReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = signinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension SigninViewController {
    func bind(reactor: SigninReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SigninReactor){
        signinView.kakaoLoginButton.rx.tap
            .map{ Reactor.Action.kakaoLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinView.appleLoginButton.rx.tap
            .bind(onNext: {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
        
        signinView.coinMonLoginButton.rx.tap
            .map{ Reactor.Action.coinMonLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinView.signupButton.rx.tap
            .map{ Reactor.Action.signupButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinView.languageSettingButton.rx.tap
            .map{ Reactor.Action.languageSettingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SigninReactor){
        reactor.state.map { $0.showToastMessage }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] show in
                if show {
                    self?.signinView.completeWithdrawalToast.isHidden = false
                    self?.signinView.completeWithdrawalToast.alpha = 1.0
                    UIView.animate(withDuration: 4.0, animations: {
                        self?.signinView.completeWithdrawalToast.alpha = 0.0
                    }, completion: { _ in
                        self?.signinView.completeWithdrawalToast.isHidden = true
                    })
                }
                else {
                    self?.signinView.completeWithdrawalToast.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentLanguage }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] language in
                if language == "ko" {
                    self?.signinView.languageSettingButton.setTitle("한국어", for: .normal)
                }
                else {
                    self?.signinView.languageSettingButton.setTitle("English", for: .normal)
                }
                self?.signinView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
}

extension SigninViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                if let fcmToken = TokenManager.shared.loadFCMToken() {
                    self.reactor?.action.onNext(.appleLoginSuccess(identityToken: identifyTokenString, authorizationCode: authCodeString, deviceToken: fcmToken))
                }
            }
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
    }
}
