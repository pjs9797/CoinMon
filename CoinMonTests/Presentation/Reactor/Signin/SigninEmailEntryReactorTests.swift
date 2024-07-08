import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Nimble
@testable import CoinMon

class SigninEmailEntryReactorTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var reactor: SigninEmailEntryReactor!
    var signinRepository: MockSigninRepository!
    var signinUseCase: SigninUseCase!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        signinRepository = MockSigninRepository()
        signinUseCase = SigninUseCase(repository: signinRepository)
        reactor = SigninEmailEntryReactor(signinUseCase: signinUseCase)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        reactor = nil
        signinRepository = nil
        signinUseCase = nil
        super.tearDown()
    }
    
    func test_updateEmail_유효한_이메일() {
        // Given
        let validEmail = "test@gmail.com"
        
        // When
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.updateEmail(validEmail))])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let observer = scheduler.createObserver(SigninEmailEntryReactor.State.self)
        
        reactor.state
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let expectedState = Recorded.next(210, SigninEmailEntryReactor.State(email: validEmail, isEmailValid: true, isClearButtonHidden: false))
        
        expect(observer.events.last).to(equal(expectedState))
    }
    
    func test_updateEmail_유효하지_않은_이메일() {
        // Given
        let invalidEmail = "invalid-email"
        
        // When
        scheduler.createHotObservable([.next(220, SigninEmailEntryReactor.Action.updateEmail(invalidEmail))])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let observer = scheduler.createObserver(SigninEmailEntryReactor.State.self)
        
        reactor.state
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let expectedState = Recorded.next(220, SigninEmailEntryReactor.State(email: invalidEmail, isEmailValid: false, isClearButtonHidden: false))
        
        expect(observer.events.last).to(equal(expectedState))
    }
    
    func test_updateEmail_이메일_업데이트() {
        // Given
        let email = "test@gmail.com"
        
        // When
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.updateEmail(email))])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let observer = scheduler.createObserver(SigninEmailEntryReactor.State.self)
        
        reactor.state
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let expectedStates = Recorded.next(210, SigninEmailEntryReactor.State(email: email, isEmailValid: true, isClearButtonHidden: false))
        
        expect(observer.events.last).to(equal(expectedStates))
    }
    
    func test_clearButtonTapped_클리어_버튼_탭() {
        // When
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.clearButtonTapped)])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let observer = scheduler.createObserver(SigninEmailEntryReactor.State.self)
        
        reactor.state
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let expectedStates = Recorded.next(210, SigninEmailEntryReactor.State(email: "", isEmailValid: false, isClearButtonHidden: true))
        
        expect(observer.events.last).to(equal(expectedStates))
    }
    
    func test_nextButtonTapped_이메일_존재() {
        // Given
        let email = "test@gmail.com"
        reactor.action.onNext(.updateEmail(email))
        
        // When
        signinRepository.checkEmailIsExistedResult = .just(SigninDTO(resultCode: "200", resultMessage: ""))
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.nextButtonTapped)])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let expectedSteps: [SigninStep] = [
            .presentToNoRegisteredEmailErrorAlertController
        ]
        
        let stepsObserver = scheduler.createObserver(SigninStep.self)
        reactor.steps
            .compactMap { $0 as? SigninStep }
            .subscribe(stepsObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        expect(stepsObserver.events.map { $0.value.element }).toEventually(equal(expectedSteps))
    }
    
    func test_nextButtonTapped_이메일_존재하지_않음() {
        // Given
        let email = "test@gmail.com"
        reactor.action.onNext(.updateEmail(email))
        
        // When
        signinRepository.checkEmailIsExistedResult = .just(SigninDTO(resultCode: "400", resultMessage: ""))
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.nextButtonTapped)])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let expectedSteps: [SigninStep] = [
            .navigateToSigninEmailVerificationNumberViewController
        ]
        
        let stepsObserver = scheduler.createObserver(SigninStep.self)
        reactor.steps
            .compactMap { $0 as? SigninStep }
            .subscribe(stepsObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        expect(stepsObserver.events.map { $0.value.element }).toEventually(equal(expectedSteps))
    }
    
    func test_nextButtonTapped_네트워크오류발생() {
        // Given
        let email = "test@gmail.com"
        reactor.action.onNext(.updateEmail(email))
        
        // When
        signinRepository.checkEmailIsExistedResult = Observable.error(NSError(domain: "NetworkError", code: -1, userInfo: nil))
        scheduler.createHotObservable([.next(210, SigninEmailEntryReactor.Action.nextButtonTapped)])
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Then
        let expectedSteps: [SigninStep] = [
            .presentToNetworkErrorAlertController
        ]
        
        let stepsObserver = scheduler.createObserver(SigninStep.self)
        reactor.steps
            .compactMap { $0 as? SigninStep }
            .subscribe(stepsObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        expect(stepsObserver.events.map { $0.value.element }).toEventually(equal(expectedSteps))
    }
}
