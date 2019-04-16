//
//  InformationViewController.swift
//  Bongo Plus
//
//  Created by Brian Schweer on 12/27/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController
{
    var navBar: UINavigationBar = UINavigationBar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        view.isOpaque = false
        view.backgroundColor = .clear
        view.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func DoneButtonPressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}



