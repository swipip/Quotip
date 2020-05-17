//
//  UserLogin.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class UserLogin: UIViewController {
    
    private lazy var backgroundImage: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = self.view.bounds
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.compact.left",withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var welcomeText: UILabel = {
        let label = UILabel()
        label.text = "Bienvenue"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        return label
    }()
    private var bottomConstraint: NSLayoutConstraint!
    private lazy var actionLabel: UILabel = {
        let label = UILabel()
        label.text = "Connexion"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    private var appleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "appleLogo")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var connectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.right",withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 30
        button.tintColor = .black
        button.addTarget(self, action: #selector(connect(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        textField.placeholder = "e-mail"
        textField.autocapitalizationType = .none
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .left
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        textField.placeholder = "mot de passe"
        textField.textAlignment = .left
        textField.tintColor = .white
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var userLoggedIn:((UserID)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(backgroundImage)
        self.navigationController?.navigationBar.isHidden = true
        
        applyGradient(self.view)
        
        addBackButton()
        addButton()
        addPasswordTextField()
        addEmailTextField()
        addLine(to: passwordTextField)
        addLine(to: emailTextField)
        addActionLabel()
        addOptionLabel()
        addAppleButton()
        addWelcomeLabel()
        
//        let loged = userDefaults.bool(forKey: K.shared.userLogedin)
        
//        if loged {
//            navigateToMainPage()
//        }
//
//        if let email = userDefaults.value(forKey: K.shared.userEmail) as? String {
//            emailTextField.text = email
//        }else{
//            actionLabel.text = "Créez votre compte"
//        }
//
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    deinit {
//        print("login denitialized")
    }
    private func applyGradient(_ view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.withAlphaComponent(0.6).cgColor,
                           UIColor.systemGreen.withAlphaComponent(0.6).cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.frame = self.view.bounds
        view.layer.addSublayer(gradient)
    }
    @objc private func backPressed(_ sender:UIButton!){
        self.navigationController?.popToRootViewController(animated: true)
    }
    private func addBackButton() {
        
        self.view.addSubview(backButton)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                         fromView.widthAnchor.constraint(equalToConstant: 50),
                                        fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 50),
                                        fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: backButton, toView: self.view)
        
    }
    fileprivate func animateError() {
        UIView.animate(withDuration: 0.5, animations: {
            self.connectButton.backgroundColor = .systemRed
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.connectButton.backgroundColor = .white
            }, completion: nil)
        }
    }
    
    @objc private func connect(_ sender:UIButton!){
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            QuotesManager.shared.logUser(withEmail: email, andPassword: password)
            QuotesManager.shared.logInAttempt = navigateToMainPage
            
        }
        
    }
    private func navigateToMainPage(user: UserID) {
        
//        userLoggedIn?(user)
        let vc = UserPageView()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    private func addOptionLabel() {
        
        self.view.addSubview(optionLabel)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                        fromView.topAnchor.constraint(equalTo: actionLabel.bottomAnchor,constant: 30)])
        }
        addConstraints(fromView: optionLabel, toView: self.backgroundImage)
        
    }
    private func addWelcomeLabel() {
        
        self.view.addSubview(welcomeText)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20)])
        }
        
        bottomConstraint = NSLayoutConstraint(item: welcomeText, attribute: .top, relatedBy: .equal, toItem: self.backgroundImage, attribute: .top, multiplier: 1, constant: 170)
        
        self.view.addConstraint(bottomConstraint)
        
        addConstraints(fromView: welcomeText, toView: self.backgroundImage)
        
    }
    private func addActionLabel() {
        
        self.view.addSubview(actionLabel)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                        fromView.centerYAnchor.constraint(equalTo: connectButton.centerYAnchor, constant: 0)])
        }
        addConstraints(fromView: actionLabel, toView: self.backgroundImage)
        
    }
    private func addButton() {
        
        self.view.addSubview(connectButton)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 60),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                         fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: -250),
                                        fromView.heightAnchor.constraint(equalToConstant: 60)])
        }
        addConstraints(fromView: connectButton, toView: self.backgroundImage)
        
    }
    private func addAppleButton() {

        self.view.addSubview(appleButton)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                         fromView.widthAnchor.constraint(equalToConstant: 50),
                                        fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 20),
                                        fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: appleButton, toView: self.optionLabel)
        
    }
    private func addPasswordTextField() {
        
        self.view.addSubview(passwordTextField)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 25),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                        fromView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -40),
                                        fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: passwordTextField, toView: self.backgroundImage)
        
    }
    private func addEmailTextField() {
        
        self.view.addSubview(emailTextField)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 25),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                         fromView.bottomAnchor.constraint(equalTo: self.passwordTextField.topAnchor, constant: -40),
                                        fromView.heightAnchor.constraint(equalToConstant: 50)])
        }
        addConstraints(fromView: emailTextField, toView: self.backgroundImage)
        
    }
    private func addLine(to view: UIView) {
        
        let line = UIView()
        line.backgroundColor = .systemGray5
        
        self.view.addSubview(line)
        
        func addConstraints(fromView: UIView, toView: UIView) {
               
           fromView.translatesAutoresizingMaskIntoConstraints = false
           
            NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                         fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -10),
                                        fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 10),
                                        fromView.heightAnchor.constraint(equalToConstant: 1)])
        }
        addConstraints(fromView: line, toView: view)
        
    }
}
extension UserLogin: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            self.bottomConstraint.constant = 170
        }
        if textField == emailTextField {
            
        }
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.backgroundImage.frame.origin.y += 170
            
            self.appleButton.alpha = 1.0
            self.optionLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.backgroundImage.frame.origin.y -= 170
            self.bottomConstraint.constant = 100
            self.appleButton.alpha = 0.0
            self.optionLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
        
        
        return true
    }
    
}

