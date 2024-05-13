//
//  RegisterVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var txtHospitalName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblSignIn: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtHospitalName.layer.cornerRadius = 16
        txtHospitalName.imageLeftSide(imageName: "User")
        txtHospitalName.layer.masksToBounds = true
        
        txtMobile.layer.cornerRadius = 16
        txtMobile.imageLeftSide(imageName: "mobile")
        txtMobile.layer.masksToBounds = true
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.imageLeftSide(imageName: "email")
        txtEmail.layer.masksToBounds = true
        
        txtPass.layer.cornerRadius = 16
        txtPass.imageLeftSide(imageName: "lock")
        txtPass.layer.masksToBounds = true
        
        btnContinue.layer.cornerRadius = 25
        btnContinue.layer.masksToBounds = true
        btnContinue.layer.shadowColor = UIColor.black.cgColor
        btnContinue.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnContinue.layer.shadowRadius = 10
        btnContinue.layer.shadowOpacity = 0.25
        btnContinue.clipsToBounds = false
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        guard let name = txtHospitalName.text,
              let email = txtEmail.text,
              let pass = txtPass.text,
              let mobile = txtMobile.text else{
            return
        }
        if name.isEmpty{
            showToastAlert(strmsg: "Name field cannot be blank", preferredStyle: .alert)
        }
        else if email.isEmpty{
            showToastAlert(strmsg: "Email field cannot be blank", preferredStyle: .alert)
        }
        else if mobile.isEmpty{
            showToastAlert(strmsg: "Mobile Number field cannot be blank", preferredStyle: .alert)
        }
        else if pass.isEmpty{
            showToastAlert(strmsg: "Password field cannot be blank", preferredStyle: .alert)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HospitalInfoRegisterStory") as! HospitalInfoVC
            vc.hospitalInfo = MedAppHospital(name: name, email: email, mobileNumber: mobile, address: Address(addressLine1: "", addressLine2: "", city: "", state: "", postalCode: "", country: "",latitude: 0.00,longitude: 0.00),type: "")
            vc.userCredentials = ["email" : email,"pass" : pass]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
