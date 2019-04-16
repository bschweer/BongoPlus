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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var emptyLabel: UILabel!
    private var favoriteStops = [Stop]()
    private var favoriteRoutes = [Route]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorites"
        
        segmentedControl.setWidth(self.view.frame.width / 3, forSegmentAt: 0)
        segmentedControl.setWidth(self.view.frame.width / 3, forSegmentAt: 1)

        // Add gestures for swipe right and swipe left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Configure label for telling user that no favorites exist
        emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        emptyLabel.text = "No Favorites to Display"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = UIColor.lightGray
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 24)
        emptyLabel.adjustsFontSizeToFitWidth = true
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Get favorite stops and routes from users defaults
        if let udData = getFavoriteStopsFromUD()
        {
            favoriteStops = udData
        }
        if let udData = getFavoriteRoutesFromUD()
        {
            favoriteRoutes = udData
        }
        
        tableView.reloadData()
        checkForEmptyTable()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        resetEditButton()
        tableView.isEditing = false
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem)
    {
        tableView.isEditing = !tableView.isEditing
        
        if tableView.isEditing
        {
            sender.title = "Done"
            sender.style = .done
        }
        else
        {
            resetEditButton()
        }
    }
    
    private func resetEditButton()
    {
        editButton.title = "Edit"
        editButton.style = .plain
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        // Ignore gesture if the user is editing their favorites
        if tableView.isEditing
        {
            return
        }
        
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
        tableView.isEditing = false
        resetEditButton()
        tableView.reloadData()
        checkForEmptyTable()
    }

    private func checkForEmptyTable()
    {
        if segmentedControl.selectedSegmentIndex == 0 && favoriteStops.isEmpty || segmentedControl.selectedSegmentIndex == 1 && favoriteRoutes.isEmpty
        {
            tableView.backgroundView = emptyLabel
        }
        else
        {
            tableView.backgroundView = nil
        }
    }
    
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
            cell.stop = favoriteStops[indexPath.row]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RoutesTableViewCell
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            let movedStop = favoriteStops[sourceIndexPath.row]
            favoriteStops.remove(at: sourceIndexPath.row)
            favoriteStops.insert(movedStop, at: destinationIndexPath.row)
            writeFavoriteStopsToUD(favoriteStops: favoriteStops)
        }
        else
        {
            let movedRoute = favoriteRoutes[sourceIndexPath.row]
            favoriteRoutes.remove(at: sourceIndexPath.row)
            favoriteRoutes.insert(movedRoute, at: destinationIndexPath.row)
            writeFavoriteRoutesToUD(favoriteRoutes: favoriteRoutes)
        }
        
        checkForEmptyTable()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            if segmentedControl.selectedSegmentIndex == 0
            {
                favoriteStops.remove(at: indexPath.row)
                writeFavoriteStopsToUD(favoriteStops: favoriteStops)
            }
            else
            {
                favoriteRoutes.remove(at: indexPath.row)
                writeFavoriteRoutesToUD(favoriteRoutes: favoriteRoutes)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkForEmptyTable()
        }
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
                let cell = tableView.cellForRow(at: indexPath) as? StopCell
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
