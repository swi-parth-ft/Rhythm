//
//  ViewController.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-07-22.
//

import UIKit
import FBSDKLoginKit
import GoogleSignInSwift
import Firebase
import GoogleSignIn

class ViewController: UIViewController {
    
    let signInConfig = GIDConfiguration(clientID: "580059371390-j1poi8dcgg95b79l85ngfldtfbvvnqnm.apps.googleusercontent.com")
    var username:String = ""
    var userEmail: String = ""
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var Register: UIStackView!
    @IBOutlet weak var loginWithFbGoogle: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var password: UIView!
    @IBOutlet weak var email: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginLabel: UIImageView!
    @IBOutlet weak var loginIllustration: UIImageView!
    
    private func animateLoginLabel() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        let offset = CGPoint(x: 0, y: -containerView.frame.maxY)
        let x: CGFloat = 0, y: CGFloat = 0
        loginLabel.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        loginLabel.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.loginLabel.transform = .identity
                self.loginLabel.alpha = 1
        })
        
        loginLabel.alpha = 0
        loginLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.loginLabel.transform = .identity
                self.loginLabel.alpha = 1
        }, completion: nil)
        
        
        
    }
    
    private func animateUsername() {
        
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.email.transform = .identity
                self.email.alpha = 1
        }, completion: nil)
    }
    
    private func animatePassword() {
        
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.password.transform = .identity
                self.password.alpha = 1
        }, completion: nil)
    }
    
    private func animateBtn(){
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white

        let offset = CGPoint(x: -containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        loginButton.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        loginButton.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.loginButton.transform = .identity
                self.loginButton.alpha = 1
            })
                loginWithFbGoogle.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
                loginWithFbGoogle.isHidden = false
                UIView.animate(
                    withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
                    options: .curveEaseOut, animations: {
                        self.loginWithFbGoogle.transform = .identity
                        self.loginWithFbGoogle.alpha = 1
        })
    }
    
    private func animateIllustration() {
      let options: UIView.AnimationOptions = [.curveEaseInOut,
                                              .repeat,
                                              .autoreverse]


        UIView.animate(withDuration: 1.5,
                     delay: 0,
                     options: options,
                     animations: { [weak self] in
          self?.loginIllustration.frame.size.height *= 1.05
                      self?.loginIllustration.frame.size.width *= 1.05
      }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        password.alpha = 0
        email.alpha = 0
        password.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        email.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        facebookLoginButton.addTarget(self, action: #selector(fbLogin), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        loginButton.alpha = 0
        loginWithFbGoogle.alpha = 0
        animateLoginLabel()
        animateUsername()
        animatePassword()
        animateBtn()
        animateIllustration()
       
    }
    
   

    @objc func fbLogin(){
        print("eeee")
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { [self] result, error in
            if error != nil{
                print("error")
            }

            GraphRequest(graphPath: "me", parameters: ["fields":"name, email"]).start { [self] connection, result, error in
                if let result = result as? [String:AnyObject] {
                    username = (result["name"] as? String)!
                    print("user: \(username)")
                    performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    
    @IBAction func loginDidTouched(_ sender: Any) {
        guard
            let email = emailField.text,
            let password = passwordField.text,
            email.count > 0,
            password.count > 0
        else {
            return
        }
        
        //2. We will perform a login with Firebase
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] user, error in
            
            if let error = error, user == nil {
                //MARK: - If signed in failed, create an alert
                let alert = UIAlertController(title: "Signed In Failed", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true)
            }else{
                self.userEmail = email
                NetworkingService.Shared.setUserEmail(email:userEmail)
                performSegue(withIdentifier: "login", sender: self)
            }
        }
        
    }
    
    
    
    @objc func googleLogin() {

//        GoogleSignInButton(action: handleSignInButton)
        GIDSignIn.sharedInstance.signIn(
          with: signInConfig,
          presenting: self) { [self] user, error in
            guard let signInUser = user else {
              print("error")
              return
            }
              performSegue(withIdentifier: "login", sender: self)
          }
        
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let MVC = segue.destination as? TabBarVC
    }

}

