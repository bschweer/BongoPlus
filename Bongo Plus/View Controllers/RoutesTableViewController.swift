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
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredRoutes = [Route]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Routes"
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        BongoServiceAPI.getAllRoutesFromAPI(completion: {
            routes in
            self.allRoutes = routes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        // Set up the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Routes"
        searchController.searchBar.barStyle = .default
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func searchBarIsEmpty() -> Bool
    {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredRoutes = allRoutes.filter({( myRoute : Route) -> Bool in
            return myRoute.routeName.lowercased().contains(searchText.lowercased())
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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath)-> IndexPath?
    {
        let selectedRoute = isFiltering() ? filteredRoutes[indexPath.row] : allRoutes[indexPath.row]
                
        guard let routeInfoVC = storyboard?.instantiateViewController(withIdentifier: "RouteInfoTableViewController") as? RouteInfoTableViewController else {return nil}
        routeInfoVC.route = selectedRoute
        
         DispatchQueue.main.async {
            self.navigationController?.pushViewController(routeInfoVC, animated: true)
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath)as! RoutesTableViewCell
        
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

