//
//  RoutesTableViewCell.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/24/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell
{
    var route: Route! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    func updateUI()
    {
        CardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 5.0
        CardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        titleLabel.text = route.routeName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
                
        if (route.agencyName == "Cambus")
        {
            ImageView.image = UIImage(named: "Cambus")
        }
        else if route.agencyName == "Coralville Transit"
        {
            ImageView.image = UIImage(named: "Coralville")
        }
        else
        {
            ImageView.image = UIImage(named: "IowaCity")
        }
    }
}
