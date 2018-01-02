//
//  JSONParser.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import MapKit

public class JSONParser
{
    public static func getAllRoutes(jsonDictionary: [String : AnyObject])->[Route]
    {
        var allRoutes = [Route]()
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
        let stopsDictionaries = jsonDictionary["stops"] as! [[String : AnyObject]]
        
        for stopDictionary in stopsDictionaries
        {
            let stopInfomation = stopDictionary["stop"] as! [String : Any]
            let newStop = Stop(dictionary: stopInfomation as [String : AnyObject])
            allStops.append(newStop)
        }
        
        return allStops
    }
    
    public static func getRouteInfo(jsonDictionary: [String : AnyObject])->RouteInfo
    {
        let routeDictionary = jsonDictionary["route"] as! [String : AnyObject]
        
        let routeInfo = RouteInfo(routeName: routeDictionary["name"] as! String)
        
        // Add the route path coordinates
        let points = routeDictionary["paths"] as! [[String : AnyObject]]
        for point in points
        {
            let pointList = point["points"] as! [[String:AnyObject]]
            
            for singlepoint in pointList
            {
                let lat = singlepoint["lat"] as! Double
                let lng = singlepoint["lng"] as! Double
                routeInfo.addCoordinate(location: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
        }
        
        // Add the stops on this route
        let stops = routeDictionary["directions"] as! [[String : AnyObject]]
        for stop in stops
        {
            let s = stop["stops"] as! [[String : AnyObject]]
            
            for stopInfomation in s
            {
                routeInfo.addStop(stop: Stop(dictionary: stopInfomation as [String : AnyObject]))
            }
        }
        
        return routeInfo
    }
    
    public static func getPredictions(jsonDictionary: [String : AnyObject])->[Prediction]
    {
        var predictions = [Prediction]()
        if jsonDictionary.count == 0
        {
            return predictions
        }
        
        let predictionsDictionary = jsonDictionary["predictions"] as! [[String : AnyObject]]
        
        for predictionEntry in predictionsDictionary
        {
            predictions.append(Prediction(dictionary: predictionEntry as [String : AnyObject]))
        }

        return predictions
    }
}



















