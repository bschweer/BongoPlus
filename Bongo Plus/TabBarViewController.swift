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
        super.viewWillLayoutSubviews()
        var tabFrame = self.tabBar.frame
        
        // Adjust size of tab bar based on device type
        let height: CGFloat
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.nativeBounds.height
            {
            case 1136: // 5S/SE
                height = 40
            case 1334: // 6/S/7/8
                height = 55
            case 2208: // 6+/S+/7+/8+
                height = 60
            case 2436: // X
                height = 90
            default: // Unknown
                height = 50
            }
        }
        else
        {
            height = 80
        }
        
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        self.tabBar.frame = tabFrame
    }
}
