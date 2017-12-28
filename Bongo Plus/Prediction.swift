//
//  Prediction.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class Prediction
{
    private let routeName: String
    private let prediction: Int
    private let direction: String
    private let agency: String
    private let agencyName: String
    
    public init(routeName: String, prediction: Int, direction: String, agency: String, agencyName: String)
    {
        self.routeName = routeName
        self.prediction = prediction
        self.direction = direction
        self.agency = agency
        self.agencyName = agencyName
    }
    
    public init(dictionary: [String : AnyObject])
    {
        self.routeName = dictionary["title"] as! String
        self.prediction = dictionary["minutes"] as! Int
        self.direction = dictionary["direction"] as! String
        self.agency = dictionary["agency"] as! String
        self.agencyName = dictionary["agencyName"] as! String
    }
    
    public func getRouteName()->String
    {
        return self.routeName
    }
    
    public func getPrediction()->Int
    {
        return self.prediction
    }
    
    public func getDirection()->String
    {
        return self.direction
    }
    
    public func getAgency()->String
    {
        return self.agency
    }
    
    public func getAgencyName()->String
    {
        return self.agencyName
    }
}
