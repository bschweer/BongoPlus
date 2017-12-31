//
//  Route.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class Route: NSObject, NSCoding
{
    let routeID: Int
    let routeName: String
    let agency: String
    let agencyName: String
    
    public init(routeID: Int, routeName: String, agency: String, agencyName: String)
    {
        self.routeID = routeID
        self.routeName = routeName
        self.agency = agency
        self.agencyName = agencyName
    }
    
    public init(dictionary: [String : AnyObject])
    {
        self.routeID = dictionary["id"] as! Int
        self.routeName = dictionary["name"] as! String
        self.agency = dictionary["agency"] as! String
        self.agencyName = dictionary["agencyname"] as! String
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        routeID = Int(aDecoder.decodeCInt(forKey: "routeID"))// decodeObject(forKey: "routeID") as! Int
        routeName = aDecoder.decodeObject(forKey: "routeName") as! String
        agency = aDecoder.decodeObject(forKey: "agency") as! String
        agencyName = aDecoder.decodeObject(forKey: "agencyName") as! String
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encodeCInt(Int32(routeID), forKey: "routeID")// (routeID, forKey: "routeID")
        aCoder.encode(routeName, forKey: "routeName")
        aCoder.encode(agency, forKey: "agency")
        aCoder.encode(agencyName, forKey: "agencyName")
    }
    
    override public func isEqual(_ object: Any?) -> Bool
    {
        return self.routeID == (object as? Route)?.routeID
    }
}
