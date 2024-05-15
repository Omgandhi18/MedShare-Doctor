//
//  IncomingAppointmentsCell.swift
//  MedShare Doctor
//
//  Created by Om Gandhi on 14/05/24.
//

import UIKit

class IncomingAppointmentsCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnViewDetails: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
