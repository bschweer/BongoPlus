//
//  PredictionTableViewCell.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/26/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class PredictionTableViewCell: UITableViewCell
{
    @IBOutlet var StopPrediction: UILabel!
    @IBOutlet var RouteName: UILabel!
    @IBOutlet var AgencyImage: UIImageView!

    var prediction: Prediction!
    {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        if prediction.getPrediction() <= 0
        {
            StopPrediction.text = "Arriving"
        }
        else if prediction.getPrediction() == 999
        {
            StopPrediction.text = ""
        }
        else
        {
            StopPrediction.text = String(prediction.getPrediction()) + " min"
        }
        
        StopPrediction.font = UIFont.boldSystemFont(ofSize: 18)
        
        if prediction.getAgency() == "uiowa"
        {
            AgencyImage.image = UIImage(named: "Cambus")
        }
        else if prediction.getAgency() == "coralville"
        {
            AgencyImage.image = UIImage(named: "Coralville")
        }
        else if (prediction.getAgency() == "none")
        {
            AgencyImage.image = nil
        }
        else // Default to Iowa City
        {
            AgencyImage.image = UIImage(named: "IowaCity")
        }
        
        RouteName.text = prediction.getRouteName()
        RouteName.font =  UIFont.boldSystemFont(ofSize: 18)
        RouteName.adjustsFontSizeToFitWidth = true
        RouteName.minimumScaleFactor = 0.1
    }
}
