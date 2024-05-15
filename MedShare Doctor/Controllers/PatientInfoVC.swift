//
//  PatientInfoVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit

class PatientInfoVC: UIViewController {

    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    @IBOutlet weak var lblBloodGrp: UILabel!
    @IBOutlet weak var lblInsurance: UILabel!
    
    var medicalInfo = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblAge.text = medicalInfo["age"] as? String
        lblGender.text = medicalInfo["gender"] as? String
        lblHeight.text = medicalInfo["height"] as? String
        lblWeight.text = medicalInfo["weight"] as? String
        lblAllergies.text = medicalInfo["allergies"] as? String
        lblBloodGrp.text = medicalInfo["blood_group"] as? String
        lblInsurance.text = medicalInfo["have_insurance"] as? Bool == true ? "Yes" : "No"
    }
    

}
