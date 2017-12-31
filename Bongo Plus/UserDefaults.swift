//
//  UserDefaults.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/29/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import Foundation

let favoriteStopsKey = "FavoriteStops"
let favoriteRoutesKey = "FavoriteRoutes"

func writeFavoriteStopsToUD(favoriteStops: [Stop])
{
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteStops)
    UserDefaults.standard.set(encodedData, forKey: favoriteStopsKey)
    UserDefaults.standard.synchronize()
}

func writeFavoriteRoutesToUD(favoriteRoutes: [Route])
{
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRoutes)
    UserDefaults.standard.set(encodedData, forKey: favoriteRoutesKey)
    UserDefaults.standard.synchronize()
}

func getFavoriteStopsFromUD()->[Stop]?
{
    var favoriteStops: [Stop]? = nil
    if UserDefaults.standard.object(forKey: favoriteStopsKey) != nil
    {
        let stopsData =  UserDefaults.standard.object(forKey: favoriteStopsKey) as! Data
        favoriteStops = NSKeyedUnarchiver.unarchiveObject(with: stopsData) as? [Stop]
    }

    return favoriteStops
}

func getFavoriteRoutesFromUD()->[Route]?
{
    var favoriteRoutes: [Route]? = nil
    if UserDefaults.standard.object(forKey: favoriteRoutesKey) != nil
    {
        let routesData =  UserDefaults.standard.object(forKey: favoriteRoutesKey) as! Data
        favoriteRoutes = NSKeyedUnarchiver.unarchiveObject(with: routesData) as? [Route]
    }
    
    return favoriteRoutes
}

