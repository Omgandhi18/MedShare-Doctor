//
//  AppointmentDetailsVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppointmentDetailsVC: UIViewController {

    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnPatientInfo: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnAdjust: UIButton!
    
    var appointmentData = [String:Any]()
    var incomingAppointments = [[String:Any]]()
    var bookedAppointments = [[String:Any]]()
    let database = Database.database().reference()
    var isFromBooked = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblID.text = String(appointmentData["appointmentId"] as? Int ?? 0)
        lblName.text = appointmentData["name"] as? String ?? ""
        lblNumber.text = appointmentData["mobile_number"] as? String ?? ""
        lblReason.text = appointmentData["reasons"] as? String ?? ""
        if appointmentData["status"] as? String == "change sent"{
            lblDateTime.text = "\(appointmentData["suggested_date"] as? String ?? "") \(appointmentData["suggested_time"] as? String ?? "")"
            btnConfirm.isHidden = true
        }
        else{
            lblDateTime.text = "\(appointmentData["date_time"] as? String ?? "")"
            btnConfirm.isHidden = false
        }
        if isFromBooked{
            btnConfirm.isHidden = true
            btnAdjust.isHidden = true
        }
        else{
            if appointmentData["status"] as? String == "change sent"{
                btnConfirm.isHidden = true
                btnAdjust.isHidden = true
            }
            else{
                btnConfirm.isHidden = false
                btnAdjust.isHidden = false
            }
           
           
        }
        
        btnCall.makeButtonRoundWithShadow()
        btnConfirm.makeButtonCurvedWithShadow(radius: 20)
        btnAdjust.makeButtonCurvedWithShadow(radius: 20)
        btnPatientInfo.makeButtonCurvedWithShadow(radius: 20)
    }
    func acceptAppointment(appointmentID: Int){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        
        var requestedArr = [[String:Any]]()
        var bookedArr = [[String:Any]]()
        incomingAppointments.forEach{appointment in
            var newAppointment = appointment
            if newAppointment["appointmentId"] as? Int ?? 0 == appointmentData["appointmentId"] as? Int ?? 0{
                newAppointment["status"] = "accepted"
                bookedArr.append(newAppointment)
            }
            else{
                requestedArr.append(newAppointment)
            }
            incomingAppointments = requestedArr
            bookedAppointments.append(contentsOf: bookedArr)
           
        }
        database.child("\(safeEmail)/incoming_appointments").setValue(incomingAppointments,withCompletionBlock: {error, _ in
            guard error == nil else{
                print("Error in setting value in incoming appointments")
                return
            }
        })
        database.child("\(safeEmail)/booked_appointments").setValue(bookedAppointments,withCompletionBlock: {error, _ in
            guard error == nil else{
                print("Error in setting value in incoming appointments")
                return
            }
        })
    }
    func setAppointmentStatusOnPatientSide(appointmentID: Int,email: String){
        database.child("\(email)/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let appointmentArr = snapshot.value as? [[String:Any]] else{
                return
            }
            var changedAppointmentArr = [[String: Any]]()
            appointmentArr.forEach{appointment in
                var newAppointment = appointment
                if newAppointment["appointmentID"] as? Int ?? 0 == appointmentID{
                    newAppointment["status"] = "accepted"
                }
                changedAppointmentArr.append(newAppointment)
            }
            database.child("\(email)/appointments").setValue(changedAppointmentArr,withCompletionBlock: {error, _ in
                guard error == nil else{
                    print("Error in setting value in appointments")
                    return
                }
                
            })
        })
    }
    
    @IBAction func btnCall(_ sender: Any) {
    }
    
    @IBAction func btnPatientInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "patientInfoStory") as! PatientInfoVC
        vc.medicalInfo = appointmentData["medical_info"] as? [String:Any] ?? [:]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        acceptAppointment(appointmentID: appointmentData["appointmentId"] as? Int ?? 0)
        setAppointmentStatusOnPatientSide(appointmentID: appointmentData["appointmentId"] as? Int ?? 0, email: appointmentData["email"] as? String ?? "")
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAdjust(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "adjustAppointmentStory") as! AdjustAppointmentVC
        vc.appointmentData = appointmentData
        vc.incomingAppointments = incomingAppointments
        vc.bookedAppointments = bookedAppointments
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
