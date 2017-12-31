//
//  MapViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/29/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var nearbyStopsButton: UIButton!
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var clearButton: UIButton!
    private let bongoLocationManager = BongoLocationManager()
    private var annotations = [MKAnnotation]()
    private var closestStops = [Stop]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        
        theMap.mapType = .standard
        theMap.showsUserLocation = true

        bongoLocationManager.setDelegate(delegate: self)
        BongoLocationManager.centerMapOnLocation(map: theMap, location: bongoLocationManager.getLocation(), animated: false)
        
        configureButton(button: clearButton)
        configureButton(button: nearbyStopsButton)

        if !bongoLocationManager.requestAuthorization()
        {
            hideButtons()
        }
    }
    
    private func configureButton(button: UIButton)
    {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.7
        button.layer.masksToBounds = false
    }
    
    private func showButtons()
    {
        clearButton.isHidden = false
    }
    
    private func hideButtons()
    {
        clearButton.isHidden = true
    }
    
    private func getStopsWithin(distance searchRadius: Double, from sourceLocation: CLLocation) -> [Stop]
    {
        let allStops = BongoAPI.getAllStopsFromAPI()
        var closeStops = [Stop]()
        
        for stop in allStops
        {
            let stopLocation = CLLocation(latitude: stop.stopLatitude, longitude: stop.stopLongitude)
            let distance = sourceLocation.distance(from: stopLocation).magnitude
            
            if distance < searchRadius
            {
                closeStops.append(stop)
            }
        }
        
        return closeStops
    }
    
    
    
    

    
    @IBAction func nearbyStopsButtonPressed()
    {
        closestStops.removeAll()
        closestStops = getStopsWithin(distance: 350, from: bongoLocationManager.getLocation())
        
        // Get rid of all old annotations
        theMap.removeAnnotations(annotations)
        BongoLocationManager.centerMapOnLocation(map: theMap, location: bongoLocationManager.getLocation(), animated: true)
        
        for stop in closestStops
        {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: stop.stopLatitude, longitude: stop.stopLongitude)
            newAnnotation.title = stop.stopName
            newAnnotation.subtitle = stop.stopNumber
            annotations.append(newAnnotation)
        }
        
        theMap.addAnnotations(annotations)
    }
    
    @IBAction func clearButtonPressed()
    {
        BongoLocationManager.centerMapOnLocation(map: theMap, location: bongoLocationManager.getLocation(), animated: true)
        theMap.removeAnnotations(annotations)
        closestStops.removeAll()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // Don't do anything is the user clicked on the blue dot for current location
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = theMap.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let infoButton = UIButton(type: UIButtonType.detailDisclosure)
            pinView!.rightCalloutAccessoryView = infoButton as UIView
        }
        else
        {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            var selectedStop: Stop? = nil
            for stop in closestStops
            {
                if (view.annotation?.subtitle)! == stop.stopNumber
                {
                    selectedStop = stop
                    break
                }
            }
            
            if selectedStop == nil
            {
                return
            }
            
            guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return}
            predictionVC.stop = selectedStop
            
            self.navigationController?.pushViewController(predictionVC, animated: true)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if CLLocationManager.locationServicesEnabled() && status == .authorizedWhenInUse
        {
            BongoLocationManager.centerMapOnLocation(map: theMap, location: bongoLocationManager.getLocation(), animated: true)
            showButtons()
        }
    }
    
    
    // Automatically called when location was updated
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        BongoLocationManager.centerMapOnLocation(map: theMap, location: location, animated: true)
    }
}
