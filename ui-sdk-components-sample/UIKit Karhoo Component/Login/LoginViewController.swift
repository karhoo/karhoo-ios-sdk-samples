//
//  LoginViewController.swift
//  UIKit Karhoo Component
//
//

import UIKit
import KarhooSDK

final class LoginViewController: UIViewController {

    private lazy var emailTextField: UITextField = {
        return UIBuilder.textField(placeholder: "email")
    }()

    private lazy var passwordTextField: UITextField = {
        return UIBuilder.textField(placeholder: "password", isSecureTextEntry: true)
    }()

    private lazy var signInButton: UIButton = {
        return UIBuilder.button(title: "Sign In")
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard Karhoo.getUserService().getCurrentUser() == nil else {
            self.goToComponentsSample()
            return
        }
    }
    
    private func setupView() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)

        _ = [emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
             emailTextField.widthAnchor.constraint(equalToConstant: 400),
             emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].map {
            $0.isActive = true
        }

        _  = [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
              passwordTextField.widthAnchor.constraint(equalTo:emailTextField.widthAnchor),
              passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)].map {
                $0.isActive = true
              }
        _ = [signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
             signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].map {
            $0.isActive = true
        }

        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
    }

    @objc private func signInPressed() {
        guard let userLogin = userLogin() else {
            return
        }

        let userService = Karhoo.getUserService()

        userService.login(userLogin: userLogin).execute { [weak self] loginResult in
            if loginResult.isSuccess() {
                self?.goToComponentsSample()
            } else {
                self?.present(UIBuilder.alert(title: "Login Failed",
                                              message: "Error: \(loginResult.errorValue()?.message ?? "unknown")"),
                             animated: true,
                             completion: nil)
            }
        }
    }

    private func userLogin() -> UserLogin? {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return nil
        }
        return UserLogin(username: email, password: password)
    }

    private func goToComponentsSample() {
        let componentSample = ComponentSampleViewController()
        componentSample.modalPresentationStyle = .fullScreen
        self.present(componentSample, animated: true, completion: nil)
    }
}
