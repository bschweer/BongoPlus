//
//  TabBarViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/27/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tabBar.barTintColor =  UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        self.tabBar.tintColor = UIColor.white
        self.tabBar.isTranslucent = false
        
        tabBar.reloadInputViews()
    }
    
    override func viewWillLayoutSubviews()
    {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 50
        tabFrame.origin.y = self.view.frame.size.height - 50
        self.tabBar.frame = tabFrame
    }
}
