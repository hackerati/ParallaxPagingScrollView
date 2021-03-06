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
        
        var newView = UIView(frame: CGRect(x: 200.0, y: 50.0, width: 100.0, height: 30.0))
        newView.backgroundColor = UIColor.greenColor()
        parallaxScrollView.addSubview(newView, type: .AlphaEffect, page: 2)
        
        var anotherView = UIView(frame: CGRect(x: 0.0, y: 120.0, width: self.view.frame.size.width, height: 30.0))
        anotherView.backgroundColor = UIColor.redColor()
        parallaxScrollView.addSubview(anotherView, type: .AlphaEffect, page: 1)
        
        var fixedView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 500.0))
        fixedView.backgroundColor = UIColor.yellowColor()
        parallaxScrollView.addFixedSubview(fixedView, pageSpan: (3, 4))
        
        var coolView = UIView(frame: CGRect(x: 50.0, y: 40.0, width: 70.0, height: 200.0))
        coolView.backgroundColor = UIColor.purpleColor()
        parallaxScrollView.addSubview(coolView, type: .NoEffect, page: 3)
        
        var dasView = UIView(frame: CGRect(x: 50.0, y: 40.0, width: 70.0, height: 300.0))
        dasView.backgroundColor = UIColor.orangeColor()
        parallaxScrollView.addSubview(dasView, type: .NoEffect, page: 4)
    }
}

