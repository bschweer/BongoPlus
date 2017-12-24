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
        
 /*       if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }*/
        
        allRoutes = BongoAPI.getAllRoutesFromAPI()
        /*
        
        let todoEndpoint: String = "http://api.ebongo.org/routelist?api_key=XXXX"
        guard let url = URL(string: todoEndpoint) else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        session.dataTask(with: url){
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
                
                self.routes = Routes.downloadBongoRoutesFromURL(jsonDictionary: todo!)
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            DispatchQueue.main.async() {
                
                self.tableView.reloadData()
            }
            
            
            }.resume()*/
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
        if isFiltering()
        {
            return filteredRoutes.count
        }
        
        return allRoutes.count
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath)->IndexPath?
    {
       /* if isFiltering()
        {
            let route = filteredRoutes[indexPath.row]
            routeglobalData.name = route.name!
            routeglobalData.agency = route.agency!
            routeglobalData.id =  route.id!
            routeglobalData.agencyName = route.agencyName!
            routeglobalData.tag = route.tag!
            
        }
        else
        {
            let route = routes[indexPath.row]
            routeglobalData.name = route.name!
            routeglobalData.agency = route.agency!
            routeglobalData.id =  route.id!
            routeglobalData.agencyName = route.agencyName!
            routeglobalData.tag = route.tag!
        }*/
        
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
/*
extension RoutesTableViewController : UIViewControllerPreviewingDelegate{
    
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? RoutesTableViewCell
            else{return nil}
        
        let identifier = "RouteInfoTableViewController"
        
        guard let RoutesVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? RouteInfoTableViewController else {return nil}
        
        RoutesVC.routeData = cell.route
        
        previewingContext.sourceRect = cell.frame
        
        
        return RoutesVC
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
    }
 
}
*/
