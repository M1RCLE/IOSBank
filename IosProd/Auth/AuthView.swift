import UIKit

class AuthViewController: UIViewController, AuthViewable {
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var presenter: AuthPresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboardObservers()
        setupTextFields()
    }
    
    @objc private func forgotPasswordTapped() {
        presenter?.forgotPasswordTapped()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Bank Login"
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(errorLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            usernameTextField.widthAnchor.constraint(equalToConstant: 300),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
   
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        presenter?.loginButtonTapped(username: username, password: password)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func displayErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.errorLabel.alpha = 0
            }
        }
    }
    
    func showLoadingState(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.loadingIndicator.startAnimating()
                self?.view.isUserInteractionEnabled = false
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
            }
        }
    }
}

extension AuthViewController {
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let loginButtonFrame = loginButton.convert(loginButton.bounds, to: view)
        if loginButtonFrame.maxY > keyboardFrame.minY {
            view.frame.origin.y = -keyboardFrame.height / 2
        }
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    private func setupTextFields() {
        usernameTextField.addTarget(self, action: #selector(validateEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
        
        usernameTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
        usernameTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
    }
    
    @objc private func validateEmail() {
        let isValid = (usernameTextField.text?.contains("@") ?? false)
                    && (usernameTextField.text?.contains(".") ?? false)
        usernameTextField.layer.borderColor = isValid
            ? UIColor.systemGray4.cgColor
            : UIColor.red.cgColor
    }
    
    @objc private func validatePassword() {
        let isValid = (passwordTextField.text?.count ?? 0) >= 6
        passwordTextField.layer.borderColor = isValid
            ? UIColor.systemGray4.cgColor
            : UIColor.red.cgColor
    }
}
