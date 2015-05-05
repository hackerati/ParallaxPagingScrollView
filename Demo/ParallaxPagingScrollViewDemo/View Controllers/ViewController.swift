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
        var parallaxScrollView = ParallaxPagingScrollView(frame: view.frame)
        parallaxScrollView.backgroundColor = UIColor.blueColor()
    }
}

