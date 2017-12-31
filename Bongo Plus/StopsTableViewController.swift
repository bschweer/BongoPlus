//
//  StopsTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class StopsTableViewController: UITableViewController
{
    private var allStops = [Stop]()
    private var filteredStops = [Stop]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Stops"
        
        // Set up the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stops"
        searchController.searchBar.barStyle = .default
        
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        BongoAPI.getAllStopsFromAPI(completion: {
            stops in
            print("size of allStops in VC is: \(stops.count)")
            self.allStops = stops
            self.tableView.reloadData()
            
            
        })

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
        
        print("size of allStops in VC is: \(allStops.count)")
        tableView.reloadData()
    }
    
    func searchBarIsEmpty()->Bool
    {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredStops = allStops.filter({( myStop : Stop) -> Bool in
            return (myStop.stopName.lowercased().contains(searchText.lowercased())) || (myStop.stopNumber.contains(searchText))
        })
        
        tableView.reloadData()
    }
    
    func isFiltering()->Bool
    {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func numberOfSections(in tableView: UITableView)->Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int
    {
        return isFiltering() ? filteredStops.count : allStops.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let selectedStop = isFiltering() ? filteredStops[indexPath.row] : allStops[indexPath.row]
        
        guard let predictionVC = storyboard?.instantiateViewController(withIdentifier: "PredictionTableViewController") as? PredictionTableViewController else {return nil}
        
        predictionVC.stop = selectedStop
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(predictionVC, animated: true)
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
        
        cell.stop = isFiltering() ? filteredStops[indexPath.row] : allStops[indexPath.row]
        return cell
    }
}

extension StopsTableViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// Add support for 3D Touch
extension StopsTableViewController : UIViewControllerPreviewingDelegate
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
