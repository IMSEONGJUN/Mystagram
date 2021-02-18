//
//  RegistrationController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import SnapKit

protocol RegistrationViewModelBindable: ViewModelType {
    // Input
    var email: PublishRelay<String> { get }
    var fullName: PublishRelay<String> { get }
    var userType: PublishRelay<String> { get }
    var password: PublishRelay<String> { get }
    var signupButtonTapped: PublishRelay<Void> { get }
    var goToLoginPageButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isRegistering: Driver<Bool> { get }
    var isRegistered: Signal<Bool> { get }
    var isFormValid: Driver<Bool> { get }
}

final class RegistrationController: UIViewController, ViewType {

    // MARK: - Properties
    
    private let emailContainer = InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: InputTextField(placeHolder: "Email"))
    private let fullNameContainer = InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: InputTextField(placeHolder: "Full Name"))
    private let passwordContainer = InputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: InputTextField(placeHolder: "Password"))
    
    private let signUpButton = GeneralConfirmButton(title: "Sign Up", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    private let goToLoginPageButton = GeneralConfirmButton(firstText: "Already have an account? ", secondText: "Log In")
    
    private lazy var stackContents = [ emailContainer,
                                       fullNameContainer,
                                       passwordContainer,
                                       signUpButton ]
    
    private let stack = UIStackView()
    
    var viewModel: RegistrationViewModelBindable!
    var disposeBag: DisposeBag!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Initial UI Setup
    func setupUI() {
        configureUIAttributeThings()
        configureInputContextStackView()
        configureGoToLoginPageButton()
        setTapGesture()
    }
    
    private func configureUIAttributeThings() {
        emailContainer.inputText.keyboardType = .emailAddress
        passwordContainer.inputText.isSecureTextEntry = true
    }
    
    private func configureInputContextStackView() {
        
        stackContents.forEach({ stack.addArrangedSubview($0) })
        stack.axis = .vertical
        stack.spacing = 20
        stack.setCustomSpacing(10, after: passwordContainer)
        
        [ emailContainer,
          fullNameContainer,
          passwordContainer,
          signUpButton ]
        .forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func configureGoToLoginPageButton() {
        view.addSubview(goToLoginPageButton)
        goToLoginPageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    // MARK: - Binding
    func bind() {
        
        // Input -> ViewModel
        signUpButton.rx.tap
            .map{ _ in Void() }
            .debug()
            .bind(to: viewModel.signupButtonTapped)
            .disposed(by: disposeBag)
        
        emailContainer.inputText.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        fullNameContainer.inputText.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.fullName)
            .disposed(by: disposeBag)
        
        passwordContainer.inputText.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
//        segment.segmentControl.rx.selectedTitle
//            .bind(to: viewModel.userType)
//            .disposed(by: disposeBag)
        
        
        // viewModel -> Output
        viewModel.isFormValid
            .drive(onNext: { [weak self] in
                self?.signUpButton.isEnabled = $0
                self?.signUpButton.backgroundColor = $0 ? #colorLiteral(red: 0.2256013453, green: 0.6298174262, blue: 0.9165520668, alpha: 1) : #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.isRegistering
            .drive(onNext: {[weak self] in
                self?.showActivityIndicator($0, withText: $0 ? "Registering" : nil)
            })
            .disposed(by: disposeBag)
        
        // UI Binding
        goToLoginPageButton.rx.tap
            .bind(to: viewModel.goToLoginPageButtonTapped)
            .disposed(by: disposeBag)
        
        
        // Notification binding
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { [weak self] noti -> CGFloat in
                guard let self = self else { fatalError() }
                return self.getKeyboardFrameHeight(noti: noti)
            }
            .subscribe(onNext: { [weak self] in
                let padding = self?.view.safeAreaInsets.bottom ?? 0
                self?.view.transform = CGAffineTransform(translationX: 0, y: -$0 - padding)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] noti -> Void in
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self?.view.transform = .identity
                })
            })
            .disposed(by: disposeBag)
    }

    
    // MARK: - Helper
    private func getKeyboardFrameHeight(noti: Notification) -> CGFloat {
        guard let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        let keyboardHeight = value.cgRectValue.height
        let bottomSpace = self.view.frame.height - (self.stack.frame.origin.y + self.stack.frame.height)
        if keyboardHeight > bottomSpace {
            let lengthToMoveUp = keyboardHeight - bottomSpace
            return lengthToMoveUp
        }
        return 0
    }
}

