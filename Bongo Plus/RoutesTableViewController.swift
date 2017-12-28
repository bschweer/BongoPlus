//
//  RoutesTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/23/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController
{
    private var allRoutes = [Route]()
    ///////////////////let routeglobalData = RouteGlobalData.sharedInstance.routeData
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredRoutes = [Route]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        self.navigationItem.title = "Routes"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        // Set up the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Routes"
        searchController.searchBar.barStyle = .blackOpaque
        searchController.searchBar.barTintColor = .white
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        allRoutes = BongoAPI.getAllRoutesFromAPI()
    }
    
    func searchBarIsEmpty() -> Bool
    {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredRoutes = allRoutes.filter({( myRoute : Route) -> Bool in
            return myRoute.getRouteName().lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool
    {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func numberOfSections(in tableView: UITableView)->Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int
    {
        return isFiltering() ? filteredRoutes.count : allRoutes.count
    }
    
    private var selectedRoute: Route? = nil
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedRoute = isFiltering() ? filteredRoutes[indexPath.row] : allRoutes[indexPath.row]
    }*/
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath)->IndexPath?
    {
        selectedRoute = isFiltering() ? filteredRoutes[indexPath.row] : allRoutes[indexPath.row]
        
        guard let routeInfoVC = storyboard?.instantiateViewController(withIdentifier: "RouteInfoTableViewController") as? RouteInfoTableViewController else {return nil}
        routeInfoVC.route = selectedRoute
        
         DispatchQueue.main.async {
            self.navigationController?.pushViewController(routeInfoVC, animated: true)
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Routecell", for: indexPath)as! RoutesTableViewCell
        
        if isFiltering()
        {
            let route = filteredRoutes[indexPath.row]
            cell.route = route
        }
        else
        {
            let route = allRoutes[indexPath.row]
            cell.route = route
        }
        
        return cell
    }
}

extension RoutesTableViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// Add support for 3D Touch
extension RoutesTableViewController : UIViewControllerPreviewingDelegate
{
    // Peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? RoutesTableViewCell
            else{return nil}
        
        guard let routeInfoVC = storyboard?.instantiateViewController(withIdentifier: "RouteInfoTableViewController") as? RouteInfoTableViewController else {return nil}
        
        routeInfoVC.route = cell.route
        previewingContext.sourceRect = cell.frame
        
        return routeInfoVC
    }
    
    // Pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

