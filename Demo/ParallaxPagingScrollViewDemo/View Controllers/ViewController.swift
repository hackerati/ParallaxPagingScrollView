//
//  ViewController.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/5/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var parallaxScrollView = ParallaxPagingScrollView(frame: view.frame, numberOfPages: 5)
        parallaxScrollView.backgroundColor = UIColor.blueColor()
        parallaxScrollView.pagingEnabled = true
        parallaxScrollView.pagingControlsEnabled = true
        view.addSubview(parallaxScrollView)
        
        var newView = UIView(frame: CGRect(x: 10.0, y: 50.0, width: 100.0, height: 30.0))
        newView.backgroundColor = UIColor.greenColor()
        parallaxScrollView.addSubview(newView, type: .AlphaEffect, page: 2)
        
        var anotherView = UIView(frame: CGRect(x: 0.0, y: 120.0, width: self.view.frame.size.width, height: 30.0))
        anotherView.backgroundColor = UIColor.redColor()
        parallaxScrollView.addSubview(anotherView, type: .AlphaEffect, page: 1)
    }
}

