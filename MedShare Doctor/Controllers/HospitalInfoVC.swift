//
//  HospitalInfoVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import UIKit

class HospitalInfoVC: UIViewController {

    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnOpenMap: UIButton!
    
    var hospitalInfo = MedAppHospital(name: "", email: "", mobileNumber: "", address: Address(addressLine1: "", addressLine2: "", city: "", state: "", postalCode: "", country: "",latitude: 0.00,longitude: 0.00))
    var userCredentials = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOpenMap(_ sender: Any) {
        
    }
    
}
