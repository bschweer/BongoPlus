//
//  BongoAPI.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class BongoServiceAPI
{
    private static let baseUrl = "https://api.ebongo.org/"
    private static let apiKey = "api_key=XXXX"
    
    private static let allRoutesURL: String = baseUrl + "routelist?" + apiKey
    private static let allStopsURL: String = baseUrl + "stoplist?" + apiKey

    
    private static var allRoutes = [Route]()
    private static var allStops = [Stop]()
    
   /* public static func getAllRoutesFromAPI()->[Route]
    {
        if allRoutes.count == 0
        {
            let dictionary = makeRequest(url: allRoutesURL)
            if dictionary.count > 0
            {
                allRoutes = JSONParser.getAllRoutes(jsonDictionary: dictionary)
            }
        }
        
        return allRoutes
    }*/
    
    public static func getAllRoutes()->[Route]
    {
        return allRoutes
    }
    
    public static func getAllRoutesFromAPI(completion:  @escaping (_ routes: [Route]) -> Void)
    {
        if allRoutes.count == 0
        {
            makeRequest(url: allRoutesURL, completion: {
                dictionary in
                
                allRoutes = JSONParser.getAllRoutes(jsonDictionary: dictionary)
                completion(allRoutes)
            })
        }
        else
        {
            completion(allRoutes)
        }
    }
    
    /*public static func getAllStopsFromAPI()->[Stop]
    {
        if allStops.count == 0
        {
            let dictionary = [String:AnyObject]()//makeRequest(url: allStopsURL)
            if dictionary.count > 0
            {
                allStops = JSONParser.getAllStops(jsonDictionary: dictionary)
            }
        }
        
        return allStops
    }*/
    
    public static func getAllStops()->[Stop]
    {
        return allStops
    }
    
    public static func getAllStopsFromAPI(completion:  @escaping (_ stops: [Stop]) -> Void)
    {
        if allStops.count == 0
        {
            makeRequest(url: allStopsURL, completion: {
                dictionary in
                
                allStops = JSONParser.getAllStops(jsonDictionary: dictionary)
                completion(allStops)
            })
        }
        else
        {
            completion(allStops)
        }
    }
    
    
    /*public static func getRouteInfo(agency: String, routeID: Int)->RouteInfo
    {
        var dictionary = [String : AnyObject]()
        
        let url = prefix + "route?agency=" + agency + "&route=\(routeID)&" + apiKey
        dictionary = makeRequest(url: url)
        
        return JSONParser.getRouteInfo(jsonDictionary: dictionary)
    }*/
    
    
    public static func getRouteInfo(agency: String, routeID: Int, completion:  @escaping (_ routeInfo: RouteInfo) -> ())
    {
        let url = baseUrl + "route?agency=" + agency + "&route=\(routeID)&" + apiKey
        makeRequest(url: url, completion: {
            dictionary in
            completion(JSONParser.getRouteInfo(jsonDictionary: dictionary))
        })
    }
    
    
    
    /*public static func getPredictions(stopNumber: String)->[Prediction]
    {
        let dictionary = makeRequest(url: url)
        return JSONParser.getPredictions(jsonDictionary: dictionary)
    }*/
    
    public static func getPredictions(stopNumber: String, completion:  @escaping (_ predictions: [Prediction]) -> ())
    {
        let url = baseUrl + "prediction?stopid=" + stopNumber + "&" + apiKey
        makeRequest(url: url, completion: {
            dictionary in
            completion(JSONParser.getPredictions(jsonDictionary: dictionary))
        })
    }
    
    
    /*private static func makeRequest(url: String)->[String:AnyObject]
    {
        var dictionary = [String:AnyObject]()
        
        let requestURL = URL(string: url)
        URLSession.shared.dataTask(with: requestURL!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String :  AnyObject]
            }
            catch let error as NSError
            {
                print(error)
            }
        }).resume()
        
        // Wait for result to be populated
        var count: Int = 0
        while(dictionary.count == 0)
        {
            count += 1
            usleep(10000)
            if count > 250
            {
                break
            }
        }
        
        return dictionary
    }*/
    
    
    
    
    private static func makeRequest(url urlString: String, completion: @escaping (_ jsonDict: [String : AnyObject]) -> ())
    {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else { return }
            // make sure we got data
            guard let responseData = data else { return }

            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else { return }
                
                completion(dictionary)
            }
            catch {
                return
            }
        }
        task.resume()
    }
}
