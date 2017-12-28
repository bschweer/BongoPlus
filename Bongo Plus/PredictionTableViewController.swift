//
//  PredictionTableViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/26/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class PredictionTableViewController: UITableViewController
{
    public var stop: Stop!
    
    private var refresher: UIRefreshControl!
    private let headerview = UIView()
    private var headerLabel = UILabel()
    private var headerLabelSubtitle = UILabel()
    private var predictions = [Prediction]()
    private var favoriteStops = [Stop]()
    private var isFavoriteButtonPressed = false
    private var favoritesNeedUpdate = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabelSubtitle.adjustsFontSizeToFitWidth = true
        
        // Configure the cells for the table
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionHeaderHeight = 70
        
        // Add support for pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(PredictionTableViewController.populate), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)

        let favoriteButton = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(favoriteButtonPressed))
        
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        // Self-update 15 second intervals
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(PredictionTableViewController.update), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.populate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        headerLabel.text = stop.getStopName()
        headerLabelSubtitle.text = stop.getStopNumber()
        
        predictions = BongoAPI.getPredictions(stopNumber: stop.getStopNumber())
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
        
        if UserDefaults.standard.object(forKey: "FavoriteStops") != nil
        {
            let stopsData =  UserDefaults.standard.object(forKey: "FavoriteStops") as! Data
            favoriteStops = NSKeyedUnarchiver.unarchiveObject(with: stopsData) as! [Stop]
            
            var stopIsFavorite = false
            for stop in favoriteStops
            {
                if self.stop == stop
                {
                    stopIsFavorite = true
                    break
                }
            }
            
            if stopIsFavorite
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
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteStops)
            UserDefaults.standard.set(encodedData, forKey: "FavoriteStops")
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
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.98, green: 0.22, blue:0.35, alpha: 1.0)
            favoriteStops.append(stop)
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            // Remove this stop from the favorites array
            for i in 0...favoriteStops.count - 1
            {
                if favoriteStops[i] == stop
                {
                    favoriteStops.remove(at: i)
                    break
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int
    {
        return predictions.count == 0 ? 1 : predictions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath) as! PredictionTableViewCell
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 4, y: 12, width: self.view.frame.size.width - 6, height: 55))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        if predictions.count == 0
        {
            let noBusesRunning: Prediction = Prediction(routeName: "No Buses Running", prediction: 999, direction: "", agency: "none", agencyName: "none")
            cell.prediction = noBusesRunning
        }
        else
        {
            cell.prediction = predictions[indexPath.row]
        }
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int)->UIView?
    {
        headerview.backgroundColor = UIColor.clear
        headerview.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        headerview.layer.masksToBounds = false
        headerview.layer.cornerRadius = 5.0
        headerview.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        headerLabel.text =  stop.getStopName()
        headerLabel.frame = CGRect(x: 10, y: 5, width: view.frame.width - 16, height: 30)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerLabelSubtitle.text =  "Stop " + stop.getStopNumber()
        headerLabelSubtitle.frame = CGRect(x: 10, y: 35, width: view.frame.width, height: 30)
        headerLabelSubtitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        headerview.addSubview(headerLabel)
        headerview.addSubview(headerLabelSubtitle)
        
        return headerview
    }
    
    @objc func populate()
    {
        predictions = BongoAPI.getPredictions(stopNumber: stop.getStopNumber())
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    @objc func update()
    {
        predictions = BongoAPI.getPredictions(stopNumber: stop.getStopNumber())
        DispatchQueue.main.async () {
            self.tableView.reloadData()
        }
        refresher.endRefreshing()
    }
}
