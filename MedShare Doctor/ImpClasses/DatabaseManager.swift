//
//  DatabaseManager.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import Foundation
import FirebaseDatabase
final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    public func insertUser(with user: MedAppHospital,completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue(["hospital_name" : user.name,
                                                 "mobile_number" : user.mobileNumber,
                                                 "incoming_appointments":[],
                                                 "booked_appointments":[],
                                                 "address":["address_line_1":user.address.addressLine1,
                                                            "address_line_2":user.address.addressLine2,
                                                            "city":user.address.city,
                                                            "state":user.address.state,
                                                            "postal_code":user.address.postalCode,
                                                            "country":user.address.country,
                                                            "latitude":user.address.latitude,
                                                            "longitude":user.address.longitude]
                                                ],withCompletionBlock: {[weak self] error, _ in
            guard let strongSelf  = self else{
                return
            }
            guard error == nil else{
                completion(false)
                return
            }
            strongSelf.database.child("hospitals").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:Any]]{
                    let newElement = [
                        "email": user.safeEmail,
                        "hospital_name" : user.name,
                        "mobile_number" : user.mobileNumber,
                        "incoming_appointments":[],
                        "booked_appointments":[],
                        "address":["address_line_1":user.address.addressLine1,
                                   "address_line_2":user.address.addressLine2,
                                   "city":user.address.city,
                                   "state":user.address.state,
                                   "postal_code":user.address.postalCode,
                                   "country":user.address.country,
                                   "latitude":user.address.latitude,
                                   "longitude":user.address.longitude]
                    ]
                    usersCollection.append(newElement)
                    strongSelf.database.child("hospitals").setValue(usersCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                        
                    })
                }
                else{
                    let newCollection:[[String: Any]] = [
                        [
                            "email": user.safeEmail,
                            "hospital_name" : user.name,
                            "mobile_number" : user.mobileNumber,
                            "incoming_appointments":[],
                            "booked_appointments":[],
                            "address":["address_line_1":user.address.addressLine1,
                                       "address_line_2":user.address.addressLine2,
                                       "city":user.address.city,
                                       "state":user.address.state,
                                       "postal_code":user.address.postalCode,
                                       "country":user.address.country,
                                       "latitude":user.address.latitude,
                                       "longitude":user.address.longitude]
                        ]
                    ]
                    strongSelf.database.child("hospitals").setValue(newCollection,withCompletionBlock: {error, _ in
                        guard error == nil else{
                            return
                        }
                        completion(true)
                        
                    })
                }
            })
            
            
        })
    }
    public func getAllUsers(completion: @escaping (Result<[[String:String]],Error>)->Void){
        database.child("hospitals").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [[String:String]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    public func userExists(with email: String, completion: @escaping ((Bool)-> Void)){
        let safeEmail = DatabaseManager.safeEmail(email: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    public func getDataFor(path: String,completion: @escaping (Result<Any,Error>) -> Void){
        self.database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
}
struct MedAppHospital{
    var name: String
    var email: String
    var mobileNumber: String
    var address: Address
    
    
    var safeEmail: String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
struct Address{
    var addressLine1: String
    var addressLine2: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    var latitude: Double
    var longitude: Double
}
struct AppointmentData{
    var appointmentID: String
    var name: String
    var mobileNumber: String
    var reasons: String
    var dateTime: String
    var medicalInfo: PatientMedicalInfo
}
struct PatientMedicalInfo{
    var age: String
    var gender: String
    var height: String
    var weight: String
    var allergies: String
    var bloodGrp: String
    var insurance: Bool
}
