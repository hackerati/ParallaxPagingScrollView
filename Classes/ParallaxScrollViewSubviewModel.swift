//
//  ParallaxScrollViewSubview.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/6/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import UIKit

struct ParallaxScrollViewSubviewModel
{
    private(set) var pageNumber: Int
    private(set) var view: UIView
    
    init(view: UIView, pageNumber: Int)
    {
        self.pageNumber = pageNumber
        self.view = view
    }
}
