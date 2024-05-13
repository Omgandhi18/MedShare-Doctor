//
//  LoginVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import UIKit
import FirebaseAuth
class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var lblRegisterNow: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblRegisterNow.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(registerBtn))
        lblRegisterNow.addGestureRecognizer(tap)
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.imageLeftSide(imageName: "User")
        txtEmail.layer.masksToBounds = true
        
        txtPass.layer.cornerRadius = 16
        txtPass.imageLeftSide(imageName: "lock")
        txtPass.layer.masksToBounds = true
        
        btnSignIn.layer.cornerRadius = 25
        btnSignIn.layer.masksToBounds = true
        btnSignIn.layer.shadowColor = UIColor.black.cgColor
        btnSignIn.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnSignIn.layer.shadowRadius = 10
        btnSignIn.layer.shadowOpacity = 0.25
        btnSignIn.clipsToBounds = false
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        guard let email = txtEmail.text,
              let pass = txtPass.text else{
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass,completion: {[weak self] authResult,error in
            guard let strongSelf = self else{
                return
            }
//            DispatchQueue.main.async {
//                strongSelf.spinner.dismiss()
//            }
            guard let result = authResult, error == nil else{
                print("Failed to log in")
                strongSelf.showToastAlert(strmsg: "Failed to log in", preferredStyle: .alert)
                return
            }
            let user = result.user
            let safeEmail = DatabaseManager.safeEmail(email: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: {result in
                switch result{
                case .success(let data):
                    guard let userData = data as? [String:Any],
                    let name = userData["full_name"] else{
                        return
                    }
//                    UserDefaults.standard.set(name, forKey: "name")
                case .failure(let error):
                    print("Failed to read data with error \(error)")
                }
            })
//            UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
            
            strongSelf.showToastAlert(strmsg: "Logged In successfully", preferredStyle: .alert)
            
//            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBarStory")
            UIApplication.shared.windows.first?.rootViewController = vc
        })
    }
    @objc func registerBtn(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStory") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
