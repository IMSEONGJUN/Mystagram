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
import RxOptional

protocol RegistrationViewModelBindable: ViewModelType {
    // Input
    var profileImage: PublishRelay<UIImage?> { get }
    var email: PublishRelay<String> { get }
    var fullName: PublishRelay<String> { get }
    var userName: PublishRelay<String> { get }
    var password: PublishRelay<String> { get }
    var signupButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isRegistering: Driver<Bool> { get }
    var isRegistered: Signal<Bool> { get }
    var isFormValid: Driver<Bool> { get }
}

final class RegistrationController: UIViewController, UINavigationControllerDelegate, ViewType {

    // MARK: - Properties
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let emailTextField = InputTextField(placeHolder: "Email")
    private let passwordTextField = InputTextField(placeHolder: "Password")
    private let fullNameTextField = InputTextField(placeHolder: "Full Name")
    private let userNameTextField = InputTextField(placeHolder: "Full Name")
    
    private let signUpButton = GeneralConfirmButton(title: "Sign Up", color: #colorLiteral(red: 0.4086206853, green: 0.3878411353, blue: 0.9632868171, alpha: 1))
    private let goToLoginPageButton = CustomButtonForAuth(firstText: "Already have an account? ", secondText: "Log In")
    
    private lazy var stackContents = [ emailTextField,
                                       fullNameTextField,
                                       passwordTextField,
                                       userNameTextField,
                                       signUpButton ]
    
    private let stack = UIStackView()
    private let picker = UIImagePickerController()
    
    var viewModel: RegistrationViewModelBindable!
    var disposeBag: DisposeBag!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Initial UI Setup
    func setupUI() {
        configureGradientLayer()
        configureUIAttributeThings()
        configurePlusPhotoButton()
        configureInputContextStackView()
        configureGoToLoginPageButton()
        setTapGesture()
    }
    
    private func configureUIAttributeThings() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
    }
    
    private func configurePlusPhotoButton() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
            $0.width.height.equalTo(view.snp.width).multipliedBy(0.35)
        }
    }
    
    private func configureInputContextStackView() {
        stackContents.forEach({ stack.addArrangedSubview($0) })
        stack.axis = .vertical
        stack.spacing = 20
        
        [ emailTextField,
          passwordTextField,
          fullNameTextField,
          userNameTextField,
          signUpButton ]
        .forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(plusPhotoButton.snp.bottom).offset(50)
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
        
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        fullNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.fullName)
            .disposed(by: disposeBag)
        
        userNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        
        
        // viewModel -> Output
        viewModel.isFormValid
            .drive(onNext: { [weak self] in
                self?.signUpButton.isEnabled = $0
                self?.signUpButton.backgroundColor = $0 ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.4086206853, green: 0.3878411353, blue: 0.9632868171, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.isRegistering
            .drive(onNext: {[weak self] in
                self?.showActivityIndicator($0, withText: $0 ? "Registering" : nil)
            })
            .disposed(by: disposeBag)
        
        // UI Binding
        goToLoginPageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        picker.rx.didFinishSelectImage
            .bind(to: viewModel.profileImage)
            .disposed(by: disposeBag)
        
        picker.rx.didFinishSelectImage
            .bind(to: self.rx.setProfileImageButton)
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

