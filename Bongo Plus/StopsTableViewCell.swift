//
//  StopsTableViewCell.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class StopsTableViewCell: UITableViewCell
{
    @IBOutlet weak var Stoptitle: UILabel!
    @IBOutlet weak var Stopnumber: UILabel!
    @IBOutlet weak var MyCardView: UIView!
    
    var stop: Stop! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        Stoptitle.text = stop.getStopName()
        Stoptitle.font = UIFont.boldSystemFont(ofSize: 18)
        Stoptitle.adjustsFontSizeToFitWidth = true
        Stoptitle.minimumScaleFactor = 0.1
        Stopnumber.text  =  "Stop " + stop.getStopNumber()
        
        MyCardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        MyCardView.layer.masksToBounds = false
        MyCardView.layer.cornerRadius = 5.0
        MyCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
