//
//  JSONParser.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class JSONParser
{
    public static func getAllRoutes(jsonDictionary: [String : AnyObject])->[Route]
    {
        var allRoutes = [Route]()
        print("dictionary: ")
        print(jsonDictionary.keys)
        let routesDictionaries = jsonDictionary["routes"] as! [[String : AnyObject]]
        
        for routeDictionary in routesDictionaries
        {
            let routeInfomation = routeDictionary["route"] as! [String : Any]
            let newRoute = Route(dictionary: routeInfomation as [String : AnyObject])
            allRoutes.append(newRoute)
        }
        
        return allRoutes
    }
    
    public static func getAllStops(jsonDictionary: [String : AnyObject])->[Stop]
    {
        var allStops = [Stop]()
        let stopsDictionaries = jsonDictionary["stops"] as! [[String:AnyObject]]
        
        for stopDictionary in stopsDictionaries
        {
            let stopInfomation = stopDictionary["stop"] as! [String : Any]
            let newStop = Stop(dictionary: stopInfomation as [String : AnyObject])
            allStops.append(newStop)
        }
        
        return allStops
    }
}
