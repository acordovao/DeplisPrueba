//
//  LoginViewController.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 07/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelErrorUser: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var labelInvalidLogin: UILabel!
    
    //ViewModel
    var model = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUser.delegate = self
        textFieldPassword.delegate = self
        
        clearMessages()
        
    }

    
    
    @IBAction func loginCliked(_ sender: Any) {
        
        clearMessages()
        
        switch model.validInformation(user: textFieldUser.text, password: textFieldPassword.text){
            
        case .userAndPasswordEmpty:
            labelErrorUser.isHidden = false
            labelErrorPassword.isHidden = false
        case .userEmpty:
            labelErrorUser.isHidden = false
        case .passwordEmpty:
            labelErrorPassword.isHidden = false
        case .success:
            
            model.sendLoginUser(user: textFieldUser.text!, password: textFieldPassword.text!){ [weak self] reponse in
                
                DispatchQueue.main.async {
                    
                    if reponse {
                        
                        let secondView = HomeViewController(nibName: "HomeViewController", bundle: nil)
                        
                        let navigationControll = UINavigationController(rootViewController: secondView)
                        
                        navigationControll.navigationBar.isHidden = true
                        
                        UIApplication.shared.windows.first?.rootViewController = navigationControll
                        
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }else{
                        
                        self?.labelInvalidLogin.isHidden = false
                        
                    }
                    
                }
                
                
                
            }
            
            
        }
        
    }
    
    private func clearMessages(){
        labelErrorUser.isHidden = true
        labelErrorPassword.isHidden = true
        labelInvalidLogin.isHidden = true
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
