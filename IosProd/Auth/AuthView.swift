import UIKit

class AuthViewController: UIViewController, AuthViewable {
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameTextField: TextInput = {
        let textField = TextInput()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: TextInput = {
        let textField = TextInput()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var errorLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Colors.primary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var formStackView: StackView = {
        let stack = StackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties
    var presenter: AuthPresentable?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        setupUI()
        setupActions()
        setupKeyboardObservers()
    }
    
    // MARK: - Actions
    @objc private func forgotPasswordTapped() {
        presenter?.forgotPasswordTapped()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Bank Login"
        
        // Configure components
        titleLabel.configure(with: LabelViewModel(
            text: "Welcome",
            style: .largeTitle,
            alignment: .center
        ))
        
        subtitleLabel.configure(with: LabelViewModel(
            text: "Please sign in to continue",
            style: .body,
            color: Colors.onBackground.withAlphaComponent(0.6),
            alignment: .center
        ))
        
        usernameTextField.configure(with: TextInputViewModel(
            placeholder: "Email",
            style: .outlined,
            leftIcon: UIImage(systemName: "envelope"),
            onTextChange: { [weak self] text in
                self?.presenter?.validateEmail(text)
            }
        ))
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.returnKeyType = .next
        
        passwordTextField.configure(with: TextInputViewModel(
            placeholder: "Password",
            style: .outlined,
            isSecure: true,
            leftIcon: UIImage(systemName: "lock"),
            rightIcon: UIImage(systemName: "eye.slash"),
            onTextChange: { [weak self] text in
                self?.presenter?.validatePassword(text)
            }
        ))
        passwordTextField.returnKeyType = .done
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        
        loginButton.configure(with: ButtonViewModel(
            title: "Login",
            style: .primary,
            action: { [weak self] in
                self?.loginButtonTapped()
            }
        ))
        
        forgotPasswordButton.configure(with: ButtonViewModel(
            title: "Forgot Password?",
            style: .text,
            action: { [weak self] in
                self?.presenter?.forgotPasswordTapped()
            }
        ))
        
        errorLabel.configure(with: LabelViewModel(
            text: "",
            style: .error,
            alignment: .center
        ))
        errorLabel.alpha = 0
        
        // Configure stack view
        formStackView.configure(with: StackViewConfig(
            axis: .vertical,
            spacing: Spacing.large
        ))
        
        // Add arranged subviews
        formStackView.addArrangedSubviews([
            titleLabel,
            subtitleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            forgotPasswordButton,
            errorLabel
        ])
        
        // Hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStackView)
        view.addSubview(loadingIndicator)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.xxLarge),
            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.xLarge),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.xLarge),
            formStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Spacing.xxLarge),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Keyboard Handling
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
        let keyboardHeight = keyboardFrame.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    // MARK: - Validation Updates
    func updateEmailFieldValidation(isValid: Bool) {
        usernameTextField.configure(with: TextInputViewModel(
            placeholder: "Email",
            style: isValid ? .outlined : .error,
            leftIcon: UIImage(systemName: "envelope"),
            onTextChange: { [weak self] text in
                self?.presenter?.validateEmail(text)
            }
        ))
    }
        
    func updatePasswordFieldValidation(isValid: Bool) {
        passwordTextField.configure(with: TextInputViewModel(
            placeholder: "Password",
            style: isValid ? .outlined : .error,
            isSecure: true,
            leftIcon: UIImage(systemName: "lock"),
            rightIcon: UIImage(systemName: "eye.slash"),
            onTextChange: { [weak self] text in
                self?.presenter?.validatePassword(text)
            }
        ))
    }
    
    // MARK: - Helper Methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginButtonTapped() {
        presenter?.loginButtonTapped(
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    // MARK: - AuthViewable Protocol Implementation
    func displayErrorMessage(_ message: String) {
        errorLabel.configure(with: LabelViewModel(
            text: message,
            style: .error,
            alignment: .center
        ))
        
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
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = !isLoading
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
