//
//  ParallaxPagingScrollView.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/5/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import Foundation
import UIKit

class ParallaxPagingScrollView : UIScrollView, UIScrollViewDelegate {
    
    private let pagingControlHeight: CGFloat = 25.0
    
    private let numberOfPages: Int
    private var pageOrigins = Array<CGPoint>()
    private var currentPage: Int = 0
    
    private var pagingIndicator: UIPageControl!
    var pagingControlsEnabled: Bool {
        didSet {
            if self.pagingEnabled {
                self.pagingIndicator.hidden = !pagingEnabled
            }
        }
    }
    
    var pagingControlsTintColor: UIColor! {
        didSet {
            self.pagingIndicator.tintColor = pagingControlsTintColor
        }
    }
    
    init(frame: CGRect, numberOfPages: Int) {
        self.numberOfPages = numberOfPages
        pagingControlsEnabled = false
        
        super.init(frame: frame)
        self.delegate = self
        self.contentSize = CGSize(width: frame.size.width * CGFloat(numberOfPages), height: frame.size.height)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        self.setupPageControls()
        
        for page in 0...(numberOfPages - 1) {
            let pageOriginX = frame.size.width * CGFloat(page)
            pageOrigins.append(CGPoint(x: pageOriginX, y: frame.origin.y))
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPageControls()
    {
        pagingIndicator = UIPageControl(frame: CGRect(x: 0.0, y: frame.size.height - pagingControlHeight, width: frame.size.width, height: pagingControlHeight))
        pagingControlsTintColor = UIColor.whiteColor()
        pagingIndicator.numberOfPages = numberOfPages
        pagingIndicator.currentPage = currentPage
        pagingIndicator.hidesForSinglePage = true
        pagingIndicator.hidden = !self.pagingEnabled
        self.addSubview(pagingIndicator)
    }
    
    
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if pagingEnabled {
            var fixedFrame = pagingIndicator.frame
            fixedFrame.origin.x = scrollView.contentOffset.x
            pagingIndicator.frame = fixedFrame
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = 1
        for origin in pageOrigins {
            if scrollView.contentOffset.x == origin.x {
                currentPage = page
                break
            }
            page += 1
        }
        pagingIndicator.currentPage = currentPage - 1
        pagingIndicator.updateCurrentPageDisplay()
    }
}
