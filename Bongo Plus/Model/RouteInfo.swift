//
//  RouteInfo.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/25/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import MapKit

public class RouteInfo
{
    let routeName: String
    private var routePath = [CLLocationCoordinate2D]()
    private var stops = [Stop]()
    
    public init(routeName: String)
    {
        self.routeName = routeName
    }
    
    public func getRoutePath()->[CLLocationCoordinate2D]
    {
        return self.routePath
    }
    
    public func getStops()->[Stop]
    {
        return self.stops
    }
    
    public func addCoordinate(location: CLLocationCoordinate2D)
    {
        routePath.append(location)
    }
    
    public func addStop(stop: Stop)
    {
        stops.append(stop)
    }
}
