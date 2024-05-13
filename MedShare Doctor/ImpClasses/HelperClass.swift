//
//  HelperClass.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 13/05/24.
//

import Foundation
import UIKit
extension UIViewController{
    func showToastAlert(strmsg : String?, preferredStyle: UIAlertController.Style) {
        let message = strmsg
        let alert = UIAlertController(title: nil, message: message, preferredStyle: preferredStyle
        )
        alert.setBackgroundColor(color: .white)
        
        // Set message font and color
        let attributedString = NSAttributedString(
            string: message ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                .foregroundColor: UIColor.main // Set the desired text color
            ]
        )

        alert.setValue(attributedString, forKey: "attributedMessage")
        //alert.setMessage(font: UIFont.systemFont(ofSize: 17,weight: .semibold), color: .ecom_main)
        alert.modalPresentationStyle = .overFullScreen
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
        // duration in seconds
        let duration: Double = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }

    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }

        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }

    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }

        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
extension UIButton{
    func makeButtonRoundWithShadow(){
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
    }
    func makeButtonCurvedWithShadow(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
    }
}
extension UITextField{
    func imageLeftSide(imageName: String){
        self.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 10))
        let image = UIImage(named: imageName)
        imageView.image = image
        
        self.leftView = imageView
    }
    func cornerRadius(radius: CGFloat){
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
}
