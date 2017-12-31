//
//  StopCell.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/25/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class StopCell: UITableViewCell
{
    @IBOutlet weak var StopTitle: UILabel!
    @IBOutlet weak var StopNumber: UILabel!
    @IBOutlet weak var CardView: UIView!
    
    var stop: Stop! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        StopTitle.text = stop.stopName
        StopTitle.font = UIFont.boldSystemFont(ofSize: 18)
        StopTitle.adjustsFontSizeToFitWidth = true
        StopTitle.minimumScaleFactor = 0.1
        StopNumber.text  =  "Stop " + stop.stopNumber
        
        CardView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.95)
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 5.0
        CardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

