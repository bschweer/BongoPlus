//
//  RoutesInfoTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/24/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit
import MapKit

class RouteInfoTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var theMap: MKMapView!
    
    public var route: Route? = nil
    
    private var selectedRouteInfo: RouteInfo? = nil
    private var favoriteRoutes = [Route]()
    
    var RouteSubList = [Route]()
    
    private var annotations = [MKPointAnnotation]()
  //////////  private var locationManager = CLLocationManager()
    
    private var isFavoriteButtonPressed = false
    private var RouteisExisted = false
    private var favoritesNeedUpdate = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = route?.getRouteName()

        let favoriteButton = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(favoriteButtonPressed))
        
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        
        self.theMap.delegate = self
        self.theMap.mapType = MKMapType.standard
        
        
 
        
        //locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager = CLLocationManager()
        
        
        /*
        // If we haven't received permission to access location, ask for it
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
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
        
        
        // Show route path and stops on the map
        DispatchQueue.main.async {
            self.selectedRouteInfo = BongoAPI.getRouteInfo(agency: (self.route?.getAgency())!, routeID: (self.route?.getRouteID())!)
            self.showRoute()
            self.showAllStops()
            self.tableView.reloadData()
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let row = tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRow(at: row, animated: false)
        }
        
        if UserDefaults.standard.object(forKey: "FavoriteRoutes") != nil
        {
            let stopsData =  UserDefaults.standard.object(forKey: "FavoriteRoutes") as! Data
            favoriteRoutes = NSKeyedUnarchiver.unarchiveObject(with: stopsData) as! [Route]
            
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
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }
    }
    
    // Save changes to favorites list if necessary
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if favoritesNeedUpdate
        {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRoutes)
            UserDefaults.standard.set(encodedData, forKey: "FavoriteRoutes")
            UserDefaults.standard.synchronize()
        }
        
        favoritesNeedUpdate = false
    }
    
    @objc func favoriteButtonPressed()
    {
        favoritesNeedUpdate = true
        isFavoriteButtonPressed = !isFavoriteButtonPressed
        
        if isFavoriteButtonPressed
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
            favoriteRoutes.append(route!)
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
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
    }
    
    
    
    
    
    
    
    func centerMapOnLocation(location: CLLocation)
    {
        let regionRadius: CLLocationDistance = 8000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        theMap.setRegion(coordinateRegion, animated: true)
    }
    
    
   
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        
        self.theMap.setRegion(region, animated: true)
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
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
    
    /*
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            routePredictionGlobalData.stoptitle = ((view.annotation?.title)!)!
            routePredictionGlobalData.stopnumber = ((view.annotation?.subtitle)!)!
            
            performSegue(withIdentifier: "routeMapToPrediction", sender: self)
        }
    }*/
    
    
    private func showAllStops()
    {
        for stopEntry in (selectedRouteInfo?.getStops())!
        {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: stopEntry.getStopLatitude(), longitude: stopEntry.getStopLongitude())
            
            newAnnotation.title = stopEntry.getStopName()
            newAnnotation.subtitle = stopEntry.getStopNumber()
            annotations.append(newAnnotation)
        }
        
        theMap.addAnnotations(annotations)
    }
    
    
    
    
    private func showRoute()
    {
        let polyLine = MKPolyline(coordinates: (selectedRouteInfo?.getRoutePath())!, count: (selectedRouteInfo?.getRoutePath().count)!)
        theMap.add(polyLine, level: MKOverlayLevel.aboveLabels)
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView)->Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedRouteInfo?.getStops().count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let selectedStop = selectedRouteInfo?.getStops()[indexPath.row]
        
        guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
        
        predictionVC.stop = selectedStop
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(predictionVC, animated: true)
        }
        
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteInfoCell", for: indexPath) as! RouteInfoTableViewCell
        
        let stop = selectedRouteInfo?.getStops()[indexPath.row]
        cell.stop = stop
        
        return cell
    }
    
    
    /*
    @objc func pushToFavourite()
    {
        if (isFavoriteButtonPressed == false)
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
            
            if(FavoriteRoutesDefault.object(forKey: "RouteDefaults") != nil )
            {
                let favoriteRouteData =  FavoriteRoutesDefault.object(forKey: "RouteDefaults") as! Data
                
                favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
                favoriteRouteList.append(routeData)
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
                
                FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
                FavoriteRoutesDefault.synchronize()
            }
            else
            {
                favoriteRouteList.append(routeData)
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
                
                FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
                FavoriteRoutesDefault.synchronize()
            }
            
            isFavoriteButtonPressed = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            print("is not favorite!")
            
            let favoriteRouteData =  FavoriteRoutesDefault.object(forKey: "RouteDefaults") as! Data
            
            var favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
            
            for i in favoriteRouteList
            {
                if (i.id != routeData.id)
                {
                    RouteSubList.append(i)
                }
            }
            
            favoriteRouteList = RouteSubList
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
            
            FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
            FavoriteRoutesDefault.synchronize()
            isFavoriteButtonPressed = false
        }
    }*/
}


// Add support for 3D Touch
extension RouteInfoTableViewController : UIViewControllerPreviewingDelegate
{
    // Peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? RouteInfoTableViewCell
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
