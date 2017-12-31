//
//  RoutesInfoTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/24/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit
import MapKit

class RouteInfoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    public var route: Route? = nil
    
    private var selectedRouteInfo: RouteInfo? = nil
    private var favoriteRoutes = [Route]()
    private var isFavoriteButtonPressed = false
    private var annotations = [MKPointAnnotation]()
    private var bongoLocationManager = BongoLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = route?.routeName
        bongoLocationManager.setDelegate(delegate: self)

        let favoriteButton = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(favoriteButtonPressed))
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        
        theMap.delegate = self
        theMap.mapType = .standard
        theMap.showsUserLocation = true
        
        bongoLocationManager.requestAuthorization()
        BongoLocationManager.centerMapOnLocation(map: theMap, location: bongoLocationManager.getLocation(), animated: false)


/*        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            theMap.showsUserLocation = true
            
            let location: CLLocation = locationManager.location ?? CLLocation(latitude: 41.660155, longitude: -91.535925)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.theMap.setRegion(region, animated: true)
        }
 */
        
        /*
                    self.centerMapOnLocation(location: self.locationManager.location ?? CLLocation(latitude: 41.660155, longitude: -91.535925))
                    
                    self.tableView.reloadData()
                    self.theMap.addAnnotations(self.showAllStops(stopEntrylist:self.stops))
                    self.showRoute(stopEntrylist: self.stops)
        */
        
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        self.selectedRouteInfo = BongoAPI.getRouteInfo(agency: (self.route?.agency)!, routeID: (self.route?.routeID)!)
        
        // Show route path and stops on the map
        DispatchQueue.main.async {
            self.showRoute()
            self.showAllStops()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        if let row = tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRow(at: row, animated: false)
        }
        
        if let udData = getFavoriteRoutesFromUD()
        {
            favoriteRoutes = udData

            var routeIsFavorite = false
            for route in favoriteRoutes
            {
                if self.route == route
                {
                    routeIsFavorite = true
                    break
                }
            }
            
            if routeIsFavorite
            {
                isFavoriteButtonPressed = true
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.98, green: 0.22, blue: 0.35, alpha: 1.0)
            }
            else
            {
                isFavoriteButtonPressed = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.gray
            }
        }
    }
    
    @objc func favoriteButtonPressed()
    {
        isFavoriteButtonPressed = !isFavoriteButtonPressed
        
        if isFavoriteButtonPressed
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.98, green: 0.22, blue:0.35, alpha: 1.0)
            favoriteRoutes.append(route!)
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.gray
            
            // Remove this stop from the favorites array
            for i in 0...favoriteRoutes.count - 1
            {
                if favoriteRoutes[i] == route
                {
                    favoriteRoutes.remove(at: i)
                    break
                }
            }
        }

        writeFavoriteRoutesToUD(favoriteRoutes: favoriteRoutes)
    }
    

    
    
    func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 8000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        theMap.setRegion(coordinateRegion, animated: true)
    }
    
    
    /*func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        
        
        /*
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        
        self.theMap.setRegion(region, animated: true)(*/
    }*/
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)->MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(hue: 0.6056, saturation: 0.61, brightness: 0.69, alpha: 1.0)
        renderer.lineWidth = 3
        
        return renderer
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)->MKAnnotationView?
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
            for stop in (selectedRouteInfo?.getStops())!
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
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(predictionVC, animated: true)
            }
        }
    }
    
    
    private func showAllStops()
    {
        for stopEntry in (selectedRouteInfo?.getStops())!
        {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: stopEntry.stopLatitude, longitude: stopEntry.stopLongitude)
            
            newAnnotation.title = stopEntry.stopName
            newAnnotation.subtitle = stopEntry.stopNumber
            annotations.append(newAnnotation)
        }
        
        theMap.addAnnotations(annotations)
    }

    private func showRoute()
    {
        let polyLine = MKPolyline(coordinates: (selectedRouteInfo?.getRoutePath())!, count: (selectedRouteInfo?.getRoutePath().count)!)
        theMap.add(polyLine, level: MKOverlayLevel.aboveLabels)
    }

    func numberOfSections(in tableView: UITableView)->Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedRouteInfo?.getStops().count ?? 1
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let selectedStop = selectedRouteInfo?.getStops()[indexPath.row]
        
        guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
        predictionVC.stop = selectedStop
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(predictionVC, animated: true)
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
        let stop = selectedRouteInfo?.getStops()[indexPath.row]
        cell.stop = stop
        
        return cell
    }
}

// Add support for 3D Touch
extension RouteInfoTableViewController : UIViewControllerPreviewingDelegate
{
    // Peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? StopCell
            else{return nil}
        
        guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
        
        predictionVC.stop = cell.stop
        previewingContext.sourceRect = cell.frame
        
        return predictionVC
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
