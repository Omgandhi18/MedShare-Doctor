//
//  HospitalInfoVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import UIKit
import CoreLocation

class HospitalInfoVC: UIViewController {

    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnOpenMap: UIButton!
    @IBOutlet weak var txtType: UITextField!
    
    var hospitalInfo = MedAppHospital(name: "", email: "", mobileNumber: "", address: Address(addressLine1: "", addressLine2: "", city: "", state: "", postalCode: "", country: "",latitude: 0.00,longitude: 0.00),type: "")
    var userCredentials = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtAddress1.cornerRadius(radius: 16)
        txtAddress2.cornerRadius(radius: 16)
        txtCity.cornerRadius(radius: 16)
        txtState.cornerRadius(radius: 16)
        txtPostalCode.cornerRadius(radius: 16)
        txtCountry.cornerRadius(radius: 16)
        txtType.cornerRadius(radius: 16)
        
        btnOpenMap.layer.cornerRadius = 25
        btnOpenMap.layer.masksToBounds = true
        btnOpenMap.layer.shadowColor = UIColor.black.cgColor
        btnOpenMap.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnOpenMap.layer.shadowRadius = 10
        btnOpenMap.layer.shadowOpacity = 0.25
        btnOpenMap.clipsToBounds = false
    }
    
    @IBAction func btnOpenMap(_ sender: Any) {
        guard let address1 = txtAddress1.text,
              let address2 = txtAddress2.text,
              let city = txtCity.text,
              let state = txtState.text,
              let postalCode = txtPostalCode.text,
              let country = txtCountry.text,
              let type = txtType.text else{
            return
        }
        if address1.isEmpty{
            showToastAlert(strmsg: "Address Line 1 cannot be blank", preferredStyle: .alert)
        }
        else if city.isEmpty{
            showToastAlert(strmsg: "City cannot be blank", preferredStyle: .alert)
        }
        else if state.isEmpty{
            showToastAlert(strmsg: "State cannot be blank", preferredStyle: .alert)
        }
        else if postalCode.isEmpty{
            showToastAlert(strmsg: "Postal code cannot be blank", preferredStyle: .alert)
        }
        else if country.isEmpty{
            showToastAlert(strmsg: "Country cannot be blank", preferredStyle: .alert)
        }
        else if type.isEmpty{
            showToastAlert(strmsg: "Type cannot be blank", preferredStyle: .alert)
        }
        else{
            var addressString = ""
            if address2.isEmpty{
                addressString = "\(address1), \(city), \(state), \(postalCode), \(country)"
            }
            else{
                addressString = "\(address1), \(address2), \(city), \(state), \(postalCode), \(country)"
            }
            
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                print("Lat: \(lat), Lon: \(lon)")
                let address = Address(addressLine1: address1, addressLine2: address2, city: city, state: state, postalCode: postalCode, country: country, latitude: lat ?? 0.00, longitude: lon ?? 0.00)
                self.hospitalInfo.address = address
                self.hospitalInfo.type = type
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapStory") as! MapVC
                vc.hospitalInfo = self.hospitalInfo
                vc.userCredentials = self.userCredentials
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        
            
        }
    }
    
}

