//
//  AdjustAppointmentVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 15/05/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AdjustAppointmentVC: UIViewController {

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var btnSendChange: UIButton!
    
    var appointmentData = [String:Any]()
    var incomingAppointments = [[String:Any]]()
    var bookedAppointments = [[String:Any]]()
    let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtDate.cornerRadius(radius: 16)
        txtDate.addInputViewDatePicker(pickerMode: .date,target: self, selector: #selector(doneButtonDatePressed))
        txtTime.cornerRadius(radius: 16)
        txtTime.addInputViewDatePicker(pickerMode: .time, target: self, selector: #selector(doneButtonTimePressed))
        btnSendChange.layer.cornerRadius = 20
        btnSendChange.layer.masksToBounds = true
        btnSendChange.layer.shadowColor = UIColor.black.cgColor
        btnSendChange.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnSendChange.layer.shadowRadius = 10
        btnSendChange.layer.shadowOpacity = 0.25
        btnSendChange.clipsToBounds = false
    }
    
    func changeAppointment(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        
        var requestedArr = [[String:Any]]()
        var bookedArr = [[String:Any]]()
        incomingAppointments.forEach{appointment in
            var newAppointment = appointment
            if newAppointment["appointmentId"] as? Int ?? 0 == appointmentData["appointmentId"] as? Int ?? 0{
                newAppointment["status"] = "change sent"
                newAppointment["suggested_date"] = txtDate.text
                newAppointment["suggested_time"] = txtTime.text
               
            }
            requestedArr.append(newAppointment)
            incomingAppointments = requestedArr
        }
        database.child("\(safeEmail)/incoming_appointments").setValue(incomingAppointments,withCompletionBlock: {error, _ in
            guard error == nil else{
                print("Error in setting value in incoming appointments")
                return
            }
        })
    }
    func setAppointmentStatusOnPatientSide(){
        database.child("\(appointmentData["email"] as? String ?? "")/appointments").observeSingleEvent(of: .value, with: {[self] snapshot in
            guard let appointmentArr = snapshot.value as? [[String:Any]] else{
                return
            }
            var changedAppointmentArr = [[String: Any]]()
            appointmentArr.forEach{appointment in
                var newAppointment = appointment
                if newAppointment["appointmentID"] as? Int ?? 0 == appointmentData["appointmentId"] as? Int ?? 0{
                    newAppointment["status"] = "change sent"
                    newAppointment["suggested_date"] = txtDate.text
                    newAppointment["suggested_time"] = txtTime.text
                }
                changedAppointmentArr.append(newAppointment)
            }
            database.child("\(appointmentData["email"] as? String ?? "")/appointments").setValue(changedAppointmentArr,withCompletionBlock: {error, _ in
                guard error == nil else{
                    print("Error in setting value in appointments")
                    return
                }
                
            })
        })
    }
    @IBAction func btnSendChange(_ sender: Any) {
        guard let date = txtDate.text,
              let time = txtTime.text else{
            return
        }
        if date.isEmpty{
            showToastAlert(strmsg: "Please select date", preferredStyle: .alert)
        }
        else if time.isEmpty{
            showToastAlert(strmsg: "Please select time", preferredStyle: .alert)
        }
        else{
            changeAppointment()
            setAppointmentStatusOnPatientSide()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func doneButtonDatePressed() {
        if let  datePicker = self.txtDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.txtDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDate.resignFirstResponder()
     }
    @objc func doneButtonTimePressed() {
        if let  datePicker = self.txtTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.txtTime.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtTime.resignFirstResponder()
     }
    

}
