//
//  LoginController.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        let email = loginEmail.text!
        let password = loginPassword.text!
        
        if (email.characters.count > 3) && (password.characters.count > 3) {
            loginEmail.layer.borderWidth = 0
            loginPassword.layer.borderWidth = 0
            
            let parameters: Parameters = ["email": email, "password": password, "grant_type": "password"]
            Alamofire.request("http://localhost:3000/oauth/token",method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.setUserDefaults(jsonResponse: json)
                case .failure(let error):
                    print(error);
                    self.showToast(message: "Invalid Credentials")
                }
            }
        } else {
            let myColor = UIColor.red
            loginEmail.layer.borderColor = myColor.cgColor
            loginPassword.layer.borderColor = myColor.cgColor
            loginEmail.layer.borderWidth = 1.0
            loginPassword.layer.borderWidth = 1.0
        }
    }
    
    func setUserDefaults(jsonResponse: JSON) {
        UserDefaults.standard.setIsLoggedIn(value: true)
        UserDefaults.standard.setAccessToken(value: jsonResponse["access_token"].string!)
        UserDefaults.standard.setRefreshToken(value: jsonResponse["refresh_token"].string!)
        
        self.performSegue(withIdentifier: "successLoginSegueIdentifier", sender: nil)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var vc: UIViewController?
//        vc = storyboard.instantiateInitialViewController()
        
    }
    
}
