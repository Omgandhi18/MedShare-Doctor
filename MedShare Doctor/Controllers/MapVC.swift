//
//  MapVC.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import UIKit
import MapKit
import FirebaseAuth
class MapVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnRegister: UIButton!
    
    
    var hospitalInfo =  MedAppHospital(name: "", email: "", mobileNumber: "", address: Address(addressLine1: "", addressLine2: "", city: "", state: "", postalCode: "", country: "",latitude: 0.00,longitude: 0.00),type: "")
    var userCredentials = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let region = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: hospitalInfo.address.latitude, longitude: hospitalInfo.address.longitude), latitudinalMeters: CLLocationDistance(exactly: 500)!, longitudinalMeters: CLLocationDistance(exactly: 500)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
       
        btnRegister.layer.cornerRadius = 25
        btnRegister.layer.masksToBounds = true
        btnRegister.layer.shadowColor = UIColor.black.cgColor
        btnRegister.layer.shadowOffset = CGSize(width: 0, height: 10)
        btnRegister.layer.shadowRadius = 10
        btnRegister.layer.shadowOpacity = 0.25
        btnRegister.clipsToBounds = false
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let center = mapView.centerCoordinate
        hospitalInfo.address.latitude = center.latitude
        hospitalInfo.address.longitude = center.longitude
        
        
        DatabaseManager.shared.userExists(with: hospitalInfo.email ?? "", completion: {[weak self] exists in
            guard let strongSelf = self else {
                return
            }
//                DispatchQueue.main.async {
//                    strongSelf.spinner.dismiss()
//                }
            guard !exists else{
                //TODO: Insert Alert
                print("user already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.userCredentials["email"] ?? "", password: strongSelf.userCredentials["pass"] ?? "",completion: {authResult, error in
                guard  authResult != nil, error == nil else{
                    print("Error creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: strongSelf.hospitalInfo, completion: {success in
                    if success
                    {
                        strongSelf.showToastAlert(strmsg: "User Created Success", preferredStyle: .alert)
                    }
                    let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBarStory")
                    UIApplication.shared.windows.first?.rootViewController = vc
                })
//                    UserDefaults.standard.set(strongSelf.txtEmail.text ?? "", forKey: "email")
//                    UserDefaults.standard.set(strongSelf.txtName.text ?? "", forKey: "name")
//                    strongSelf.navigationController?.dismiss(animated: true)
            })
        })
    }
    
}
