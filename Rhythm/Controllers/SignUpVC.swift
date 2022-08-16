//
//  SignUpVC.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-22.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameText.leftViewMode = UITextField.ViewMode.always
        let nameImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let nameImage = UIImage(named: "userSign")
        nameImageView.image = nameImage
        nameText.leftView = nameImageView
        
        emailText.leftViewMode = UITextField.ViewMode.always
        let emailImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let emailImage = UIImage(named: "emailSign")
        emailImageView.image = emailImage
        emailText.leftView = emailImageView
        
        passwordText.leftViewMode = UITextField.ViewMode.always
        let passwordImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let passwordImage = UIImage(named: "passwordSign")
        passwordImageView.image = passwordImage
        passwordText.leftView = passwordImageView
    }
    @IBAction func signUpDidTouch(_ sender: Any) {

        let emailField = emailText.text!
        let passwordField = passwordText.text!
            
        Auth.auth().createUser(withEmail: emailField, password: passwordField) { [self] user, error in
                //MARK: - If there is no error, perform a signIn using the Auth library signIn function
                if error == nil {
                    performSegue(withIdentifier: "backToLogin", sender: self)
                    Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!)
                    
                }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let MVC = segue.destination as? ViewController
    }

}
