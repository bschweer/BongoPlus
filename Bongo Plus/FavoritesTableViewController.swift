//
//  FavoritesTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/26/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var favoriteStops = [Stop]()
    private var favoriteRoutes = [Route]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        
        segmentedControl.setWidth(self.view.frame.width / 4, forSegmentAt: 0)
        segmentedControl.setWidth(self.view.frame.width / 4, forSegmentAt: 1)

        // Add gestures for swipe right and swipe left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "FavoriteRoutes") != nil
        {
            let routeData =  UserDefaults.standard.object(forKey: "FavoriteRoutes") as! Data
            favoriteRoutes = NSKeyedUnarchiver.unarchiveObject(with: routeData) as! [Route]
        }
        
        if UserDefaults.standard.object(forKey: "FavoriteStops") != nil
        {
            let stopsData =  UserDefaults.standard.object(forKey: "FavoriteStops") as! Data
            favoriteStops = NSKeyedUnarchiver.unarchiveObject(with: stopsData) as! [Stop]
        }
        
        tableView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            if swipeGesture.direction == .right
            {
                segmentedControl.selectedSegmentIndex = (segmentedControl.selectedSegmentIndex + 1)  % 2
            }
            else
            {
                segmentedControl.selectedSegmentIndex = abs(segmentedControl.selectedSegmentIndex - 1)
            }
            
            segmentedControlValueChanged()
        }
    }
    
    @IBAction func segmentedControlValueChanged()
    {
        tableView.reloadData()
    }
    

    
    
 /*   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        /*let stop = stops[indexPath.row]
         
         routePredictionGlobalData.stoptitle = stop.stoptitle!
         routePredictionGlobalData.stopnumber = stop.stopnumber!
         routePredictionGlobalData.stoplat = stop.stoplat!
         routePredictionGlobalData.stoplng = stop.stoplng!
         
         */
        let selectedStop = selectedRouteInfo?.getStops()[indexPath.row]
        
        guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
        
        predictionVC.stop = selectedStop
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(predictionVC, animated: true)
        }
        
        return indexPath
    }*/
    
    

    func numberOfSections(in tableView: UITableView)->Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int
    {
        return segmentedControl.selectedSegmentIndex == 0 ? favoriteStops.count : favoriteRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Stopscell", for: indexPath) as! StopsTableViewCell
            cell.stop = favoriteStops[indexPath.row]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Routecell", for: indexPath) as! RoutesTableViewCell
            cell.route = favoriteRoutes[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath)->IndexPath?
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
            predictionVC.stop = favoriteStops[indexPath.row]
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(predictionVC, animated: true)
            }
        }
        else
        {
            guard let routeInfoVC = storyboard?.instantiateViewController(withIdentifier: "RouteInfoTableViewController") as? RouteInfoTableViewController else {return nil}
            routeInfoVC.route = favoriteRoutes[indexPath.row]
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(routeInfoVC, animated: true)
            }
        }
        
        return indexPath
    }
}

// Add support for 3D Touch
extension FavoritesTableViewController : UIViewControllerPreviewingDelegate
{
    // Peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            guard let indexPath = tableView.indexPathForRow(at: location),
                let cell = tableView.cellForRow(at: indexPath) as? StopsTableViewCell
                else{return nil}
            
            guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
            
            predictionVC.stop = cell.stop
            previewingContext.sourceRect = cell.frame
            
            return predictionVC
        }
        else
        {
            guard let indexPath = tableView.indexPathForRow(at: location),
                let cell = tableView.cellForRow(at: indexPath) as? RoutesTableViewCell
                else {return nil}
            
            guard let routeInfoVC = storyboard?.instantiateViewController(withIdentifier: "RouteInfoTableViewController") as? RouteInfoTableViewController else {return nil}
            
            routeInfoVC.route = cell.route
            previewingContext.sourceRect = cell.frame
            
            return routeInfoVC
        }
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
