//
//  RegisterViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-02.
//

import UIKit
import ProgressHUD
class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    

    @IBAction func registerBtn(_ sender: UIButton) {
        if(emailTextField.text != "" && passwordTextField.text != "")
        {
            firebaseuserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil{
                    ProgressHUD.showSuccess("successfully registered")
                }else{
                    print(error?.localizedDescription)
                    ProgressHUD.showFailed(error?.localizedDescription)

                }
            }
        }else{
            ProgressHUD.showFailed("all fields are required")

        }
    }
    @IBAction func signIndismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
