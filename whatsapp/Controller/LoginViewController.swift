//
//  ViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-01.
//

import UIKit
import ProgressHUD
class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(endeditviewtap))
        self.view.addGestureRecognizer(tapgesture)
    }
    @objc func textfielddidschange(h:String)
    {
       
    }
    
    @objc func endeditviewtap()
    {
        self.view.endEditing(true)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func loginBtn(_ sender: UIButton) {
       
        if(emailTextField.text != "" && passwordTextField.text != "")
        {
            firebaseuserListener.shared.loginwith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil{
                    DispatchQueue.main.async {
                        self.login()
                    }
                    
                }else{
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
        }else{
            ProgressHUD.showFailed("all fields are required")
        }
    }
    
    @IBAction func signUpBtnPresent(_ sender: UIButton) {
        performSegue(withIdentifier: "registervc", sender: nil)
    }
    
    
    func login(){
     
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true)
    }
    
}

