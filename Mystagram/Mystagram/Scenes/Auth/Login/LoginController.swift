//
//  LoginController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import JGProgressHUD

protocol LoginViewModelBindable: ViewModelType {
    // Input
    var email: BehaviorSubject<String> { get }
    var password: BehaviorSubject<String> { get }
    var loginButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isLoginCompleted: Signal<Bool> { get }
    var isValidForm: Driver<Bool> { get }
}

final class LoginController: UIViewController, ViewType {

    // MARK: - Properties
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 3
        iv.clipsToBounds = true
        return iv
    }()
    
    private let emailTextField = InputTextField(placeHolder: "Email")
    private let passwordTextField = InputTextField(placeHolder: "Password")
    private let loginButton = GeneralConfirmButton(title: "Log In", color: #colorLiteral(red: 0.3600306213, green: 0.06648322195, blue: 0.9690416455, alpha: 1))
    private let goToSignUpPageButton = CustomButtonForAuth(firstText: "Don't have an account? ", secondText: "Sign Up")
    private let forgotPasswordButton = CustomButtonForAuth(firstText: "Forgot your password? ", secondText: "Get help signing in")
    
    var viewModel: LoginViewModelBindable!
    var disposeBag: DisposeBag!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Initial UI Setup
    func setupUI() {
        configureDetailAttributesOfUI()
        configureGradientLayer()
        configureLogoImageView()
        configureGoToSignUpPageButton()
        configureAuthenticationStackView()
        configureTapGesture()
    }
    
    private func configureDetailAttributesOfUI() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(80)
        }
    }
    
    private func configureGoToSignUpPageButton() {
        view.addSubview(goToSignUpPageButton)
        goToSignUpPageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureAuthenticationStackView() {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 20
        stack.setCustomSpacing(10, after: loginButton)
        [emailTextField, passwordTextField, loginButton, forgotPasswordButton].forEach({
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        })
        
        stack.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func configureTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    // MARK: - Binding
    func bind() {
        // Input -> ViewModel
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
        
        
        // viewModel -> Output
        viewModel.isValidForm
            .drive(onNext: { [weak self] in
                self?.loginButton.isEnabled = $0
                self?.loginButton.backgroundColor = $0 ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3600306213, green: 0.06648322195, blue: 0.9690416455, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoginCompleted
            .emit(onNext: { [weak self] _ in
                self?.showActivityIndicator(false)
                self?.switchToSomeVC(mainVC: MainTabBarController())
            })
            .disposed(by: disposeBag)
        
        
        // UI Binding
        loginButton.rx.tap
            .do(onNext: { [unowned self] _ in
                self.showActivityIndicator(true)
            })
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        goToSignUpPageButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let vc = RegistrationController.create(with: RegistrationViewModel())
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}



