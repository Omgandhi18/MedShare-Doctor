//
//  AppointmentsVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 14/05/24.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class AppointmentsVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
//MARK: Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tblAppointments: UITableView!
    
    //MARK: Variables
    
    var incomingAppointments = [[String:Any]]()
    var bookedAppointments = [[String:Any]]()
    var hospitalData = [String: Any]()
    var timer = Timer()
    let database = Database.database().reference()
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {[self] _ in
            getAppointments()
            })
    }
    override func viewWillAppear(_ animated: Bool) {
        getAppointments()
    }
    //MARK: Network methods
    func getAppointments(){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        database.child("\(safeEmail)").observeSingleEvent(of: .value, with: {[self] snapshot in
            if let data = snapshot.value as? [String:Any]{
                hospitalData = data
                
                incomingAppointments = hospitalData["incoming_appointments"] as? [[String:Any]] ?? []
                bookedAppointments = hospitalData["booked_appointments"] as? [[String:Any]] ?? []
                tblAppointments.delegate = self
                tblAppointments.dataSource = self
                tblAppointments.reloadData()
            }
        })
    }
    func acceptAppointment(appointmentID: Int){
        let userEmail = FirebaseAuth.Auth.auth().currentUser?.email
        let safeEmail = DatabaseManager.safeEmail(email: userEmail ?? "")
        
        var requestedArr = [[String:Any]]()
        var bookedArr = [[String:Any]]()
        incomingAppointments.forEach{appointment in
            var newAppointment = appointment
            if newAppointment["appointmentId"] as? Int ?? 0 == appointmentID{
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
        tblAppointments.reloadData()
        getAppointments()
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
    
//MARK: Btn Methods
    @IBAction func segmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0{
            tblAppointments.reloadData()
        }
        else{
            tblAppointments.reloadData()
        }
    }
    //MARK: Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0{
            return incomingAppointments.count
        }
        else{
            return bookedAppointments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "incomingAppointmentCell", for: indexPath) as! IncomingAppointmentsCell
            let appointmentData = incomingAppointments[indexPath.row]
            cell.selectionStyle = .none
            cell.viewBackground.layer.cornerRadius = 16
            cell.viewBackground.layer.masksToBounds = true
            cell.lblID.text = "Appointment ID: \(appointmentData["appointmentId"] as? Int ?? 0)"
            cell.lblName.text = "Name of Patient: \(appointmentData["name"] as? String ?? "")"
            cell.lblReason.text = "Reason for visit: \(appointmentData["reasons"] as? String ?? "")"
            if appointmentData["status"] as? String == "change sent"{
                cell.lblDateTime.text = "Date/Time:- \(appointmentData["suggested_date"] as? String ?? "") \(appointmentData["suggested_time"] as? String ?? "")"
                cell.btnAccept.isHidden = true
            }
            else{
                cell.lblDateTime.text = "Date/Time: \(appointmentData["date_time"] as? String ?? "")"
                cell.btnAccept.isHidden = false
            }
            
            cell.btnCall.tag = indexPath.row
            cell.btnCall.makeButtonRoundWithShadow()
            cell.btnCall.addTarget(self, action: #selector(callPatient(_:)), for: .touchUpInside)
            
            cell.btnAccept.tag = indexPath.row
            cell.btnAccept.makeButtonCurvedWithShadow(radius: 14)
            cell.btnAccept.addTarget(self, action: #selector(acceptAppointment(_:)), for: .touchUpInside)
            
            cell.btnViewDetails.tag = indexPath.row
            cell.btnViewDetails.makeButtonCurvedWithShadow(radius: 14)
            cell.btnViewDetails.addTarget(self, action: #selector(viewAppointmentDetails(_:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookedAppointmentCell", for: indexPath) as! BookedAppointmentsCell
            let appointmentData = bookedAppointments[indexPath.row]
            cell.selectionStyle = .none
            cell.viewBackground.layer.cornerRadius = 16
            cell.viewBackground.layer.masksToBounds = true
            cell.lblId.text = "Appointment ID: \(appointmentData["appointmentId"] as? Int ?? 0)"
            cell.lblName.text = "Name of Patient: \(appointmentData["name"] as? String ?? "")"
            cell.lblReasons.text = "Reason for visit: \(appointmentData["reasons"] as? String ?? "")"
            if appointmentData["status"] as? String == "change sent"{
                cell.lblDateTime.text = "Date/Time:- \(appointmentData["suggested_date"] as? String ?? "") \(appointmentData["suggested_time"] as? String ?? "")"
            }
            else{
                cell.lblDateTime.text = "Date/Time:- \(appointmentData["date_time"] as? String ?? "")"
            }
            cell.btnCall.tag = indexPath.row
            cell.btnCall.makeButtonRoundWithShadow()
            cell.btnCall.addTarget(self, action: #selector(callPatient(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 0{
            return 183
        }
        return 173
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex == 1{
            let appointment = bookedAppointments[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "appointmentDetailsStory") as! AppointmentDetailsVC
            vc.appointmentData = appointment
            vc.isFromBooked = true
            vc.incomingAppointments = incomingAppointments
            vc.bookedAppointments = bookedAppointments
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: Selector methods
    @objc func callPatient(_ sender: UIButton){
        
    }
    
    @objc func acceptAppointment(_ sender: UIButton){
        if segmentControl.selectedSegmentIndex == 0{
            let appointment = incomingAppointments[sender.tag]
            acceptAppointment(appointmentID: appointment["appointmentId"] as? Int ?? 0)
            setAppointmentStatusOnPatientSide(appointmentID: appointment["appointmentId"] as? Int ?? 0, email: appointment["email"] as? String ?? "")
        }
        else{
            
        }
    }
    @objc func viewAppointmentDetails(_ sender: UIButton){
        if segmentControl.selectedSegmentIndex == 0{
            let appointment = incomingAppointments[sender.tag]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "appointmentDetailsStory") as! AppointmentDetailsVC
            vc.appointmentData = appointment
            vc.incomingAppointments = incomingAppointments
            vc.bookedAppointments = bookedAppointments
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let appointment = bookedAppointments[sender.tag]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "appointmentDetailsStory") as! AppointmentDetailsVC
            vc.appointmentData = appointment
            vc.isFromBooked = true
            vc.incomingAppointments = incomingAppointments
            vc.bookedAppointments = bookedAppointments
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
