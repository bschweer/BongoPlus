//
//  BongoAPI.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

public class BongoAPI
{
    private static let prefix = "https://api.ebongo.org/"
    private static let apiKey = "XXXX"
    
    private static let allRoutesURL: String = prefix + "routelist?api_key=" + apiKey
    private static let allStopsURL: String = prefix + "stoplist?api_key=" + apiKey

    
    private static var allRoutes = [Route]()
    private static var allStops = [Stop]()
    
    public static func getAllRoutesFromAPI()->[Route]
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
    }
    
    public static func getAllStopsFromAPI()->[Stop]
    {
        if allStops.count == 0
        {
            let dictionary = makeRequest(url: allStopsURL)
            if dictionary.count > 0
            {
                allStops = JSONParser.getAllStops(jsonDictionary: dictionary)
            }
        }
        
        return allStops
    }
    
    
    private static func makeRequest(url: String)->[String:AnyObject]
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
            usleep(50000)
            if count > 50
            {
                break
            }
        }
        
        return dictionary
    }
}
