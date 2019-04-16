//
//  Stop.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class Stop: NSObject, NSCoding
{
    let stopNumber: String
    let stopName: String
    let stopLatitude: Double
    let stopLongitude: Double
    
    public init(stopNumber: String, stopName: String, stopLatitude: Double, stopLongitude: Double)
    {
        self.stopNumber = stopNumber
        self.stopName = stopName
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
    }
 
    public init(dictionary: [String : AnyObject])
    {
        self.stopNumber = dictionary["stopnumber"] as! String
        self.stopName = dictionary["stoptitle"] as! String
        self.stopLatitude = dictionary["stoplat"] as! Double
        self.stopLongitude = dictionary["stoplng"] as! Double
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        stopNumber = aDecoder.decodeObject(forKey: "stopNumber") as! String
        stopName = aDecoder.decodeObject(forKey: "stopName") as! String
        stopLatitude = aDecoder.decodeDouble(forKey: "stopLatitude")
        stopLongitude = aDecoder.decodeDouble(forKey: "stopLongitude")
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(stopNumber, forKey: "stopNumber")
        aCoder.encode(stopName, forKey: "stopName")
        aCoder.encode(stopLatitude, forKey: "stopLatitude")
        aCoder.encode(stopLongitude, forKey: "stopLongitude")
    }
    
    /*public func getStopNumber()->String
    {
        return self.stopNumber
    }
    
    public func getStopName()->String
    {
        return self.stopName
    }
    
    public func getStopLatitude()->Double
    {
        return self.stopLatitude
    }
    
    public func getStopLongitude()->Double
    {
        return self.stopLongitude
    }*/
    
    override public var hash: Int
    {
        return stopLatitude.hashValue ^ stopLongitude.hashValue &* 16777619
    }
    
    override public func isEqual(_ object: Any?) -> Bool
    {
        return self.stopNumber == (object as? Stop)?.stopNumber
    }
}
