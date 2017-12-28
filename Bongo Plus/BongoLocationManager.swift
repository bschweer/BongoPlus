//
//  BongoLocationManager.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/24/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import MapKit

class BongoLocationManager
{
    private static let locationManager = CLLocationManager()
    
    public static func requestAuthorization()
    {
        // If we haven't received permission to access location, ask for it
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        /*else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            /*theMap.showsUserLocation = true
            
            let location: CLLocation = locationManager.location ?? CLLocation(latitude: 41.660155, longitude: -91.535925)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.theMap.setRegion(region, animated: true)*/
        }*/
    }
    
    public static func getLocation()->CLLocation
    {
        return locationManager.location ?? CLLocation(latitude: 41.660155, longitude: -91.535925)
    }
    
    public static func centerMapOnLocation(map: MKMapView, location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 8000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: false)
    }
    
    
    
    public static func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        
    }
}
