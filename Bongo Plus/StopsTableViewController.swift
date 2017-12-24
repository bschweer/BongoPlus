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
    private let searchController = UISearchController(searchResultsController: nil)

    
    private var allStops = [Stop]()
    private var filteredStops = [Stop]()
   /////// private let globalDataStopToModify = StopsGlobalData.sharedInstance.selectedStops
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Stops"
        
        // Set up the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stops"
        searchController.searchBar.barStyle = .blackOpaque
        searchController.searchBar.barTintColor = .white
        
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        allStops = BongoAPI.getAllStopsFromAPI()

        
        /*if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }*/
    }
    
    
    func searchBarIsEmpty()->Bool
    {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredStops = allStops.filter({( myStop : Stop) -> Bool in
            return (myStop.getStopName().lowercased().contains(searchText.lowercased())) || (myStop.getStopNumber().contains(searchText))
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFiltering()
        {
            return filteredStops.count
        }
        
        return allStops.count
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {/*
        if isFiltering()
        {
            let stop = filteredStops[indexPath.row]
            
            globalDataStopToModify.stoptitle = stop.stoptitle!
            globalDataStopToModify.stopnumber = stop.stopnumber!
            globalDataStopToModify.stoplat = stop.stoplat!
            globalDataStopToModify.stoplng = stop.stoplng!
        }
        else
        {
            let stop = stops[indexPath.row]
            globalDataStopToModify.stoptitle = stop.stoptitle!
            globalDataStopToModify.stopnumber = stop.stopnumber!
            globalDataStopToModify.stoplat = stop.stoplat!
            globalDataStopToModify.stoplng = stop.stoplng!
        }*/
        
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Stopscell", for: indexPath) as! StopsTableViewCell
        
        if isFiltering()
        {
            let stop = filteredStops[indexPath.row]
            cell.stop = stop
        }
        else
        {
            let stop = allStops[indexPath.row]
            cell.stop = stop
        }
        
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

/*
extension StopsTableViewController : UIViewControllerPreviewingDelegate
{
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? StopsTableViewCell
            else{return nil}
        
        let identifier = "StopPredictionTableViewController"
        
        guard let StopsVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? StopPredictionTableViewController else {return nil}
        
        StopsVC.StopData = cell.stop
        
        previewingContext.sourceRect = cell.frame
        
        return StopsVC
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
*/
