//
//  ParallaxScrollViewSubview.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/6/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import UIKit

typealias animationClosure = () -> Void

class ParallaxScrollViewSubviewModel
{

    private(set) weak var view: UIView!
    private(set) var type: ParallaxViewType
    private(set) var pageNumber: Int?
    private(set) var pageRange: (Int, Int)?
    var animation: animationClosure?
    
    init(view: UIView, type: ParallaxViewType, pageNumber: Int)
    {
        self.view = view
        self.type = type
        self.pageNumber = pageNumber
    }
    
    init(view: UIView, type: ParallaxViewType, pageRange: (Int, Int))
    {
        self.view = view
        self.type = type
        self.pageRange = pageRange
    }
}
