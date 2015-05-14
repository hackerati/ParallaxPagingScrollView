//
//  ParallaxPagingScrollView.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/5/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import Foundation
import UIKit

enum ParallaxViewType
{
    case NoEffect
    case AlphaEffect
    case FixedEffect
}

class ParallaxPagingScrollView : UIScrollView, UIScrollViewDelegate {
    
    enum ScrollDirection: String {
        case Left = "Left", Right = "Right"
    }
    
    private let pagingControlHeight: CGFloat = 25.0
    
    private let numberOfPages: Int
    private(set) var pageOrigins = [CGPoint]()
    private(set) var animator: ParallaxAnimator!
    private(set) var currentPage: Int = 0
    private(set) var nextPage: Int = 1
    private(set) var currentOrigin = CGPoint(x: 0.0, y: 0.0)
    private(set) var scrollDirection = ScrollDirection.Left
    private(set) var pagingIndicator: UIPageControl!
    var pagingControlsEnabled: Bool {
        didSet {
            if pagingEnabled {
                pagingIndicator.hidden = !pagingEnabled
            }
        }
    }
    
    var pagingControlsTintColor: UIColor! {
        didSet {
            pagingIndicator.tintColor = pagingControlsTintColor
        }
    }
    
    convenience init()
    {
        self.init(frame: UIScreen.mainScreen().bounds, numberOfPages: 1)
        self.pagingEnabled = false
        self.pagingControlsEnabled = false
    }
    
    init(frame: CGRect, numberOfPages: Int) {
        self.numberOfPages = numberOfPages
        pagingControlsEnabled = false
        
        for page in 0..<numberOfPages {
            let pageOriginX = frame.size.width * CGFloat(page)
            pageOrigins.append(CGPoint(x: pageOriginX, y: frame.origin.y))
        }
        
        super.init(frame: frame)
        self.delegate = self
        self.contentSize = CGSize(width: frame.size.width * CGFloat(numberOfPages), height: frame.size.height)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        animator = ParallaxAnimator(animatorView: self)
        
        self.setupPageControls()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func setupPageControls()
    {
        pagingIndicator = UIPageControl(frame: CGRect(x: 0.0, y: frame.size.height - pagingControlHeight, width: frame.size.width, height: pagingControlHeight))
        pagingControlsTintColor = UIColor.whiteColor()
        pagingIndicator.numberOfPages = numberOfPages
        pagingIndicator.currentPage = currentPage
        pagingIndicator.hidesForSinglePage = true
        pagingIndicator.hidden = !pagingEnabled
        addFixedSubview(pagingIndicator, pageSpan: (1, numberOfPages))
    }
    
    private func animateAlphaViews()
    {
        animator.animateViewsOfType(.AlphaEffect)
    }
    
    private func fixSubviews()
    {
        animator.animateViewsOfType(.FixedEffect)
    }
    
    private func newViewRect(originalRect: CGRect, pageNumber: Int) -> CGRect
    {
        let pageOrigin = pageOrigins[pageNumber - 1]
        let newOriginX = originalRect.origin.x + pageOrigin.x
        return CGRect(origin: CGPoint(x: newOriginX, y: originalRect.origin.y), size: originalRect.size)
    }
    
    private func calculateApproachingPage() -> Int
    {
        let approachingPage : Int
        if scrollDirection == .Left {
            approachingPage = currentPage - 1
        }
        else {
            approachingPage = currentPage
        }
        
        nextPage = approachingPage
        return approachingPage
    }
    
    private func addSubview(view: UIView, page: Int)
    {
        assert(page > 0, "Page number can not be 0 or negative")
        assert(page <= numberOfPages, "Page number exceeds the amount of pages in the scroll view")
        
        view.frame = newViewRect(view.frame, pageNumber: page)
        self.addSubview(view)
    }
    
    // MARK: Public
    
    func addSubview(view: UIView, type: ParallaxViewType, page: Int)
    {
        addSubview(view, page: page)
        
        let subviewModel = ParallaxScrollViewSubviewModel(view: view, type: type, pageNumber: page - 1)
        animator.trackView(subviewModel, type: type)
    }
    
    func addFixedSubview(view: UIView, pageSpan:(Int, Int))
    {
        let (lowerBound, upperBound) = pageSpan
        assert(lowerBound < upperBound, "Page range must go in ascending order")
        assert(lowerBound > 0 && upperBound <= numberOfPages, "Page range out of bounds of number of pages")
        
        addSubview(view, page: lowerBound)
        
        let subviewModel = ParallaxScrollViewSubviewModel(view: view, type: .FixedEffect, pageRange: pageSpan)
        animator.trackView(subviewModel, type: .FixedEffect)
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if contentOffset.x >= contentSize.width - frame.size.width {
            self.setContentOffset(CGPoint(x: contentSize.width - frame.size.width, y: contentOffset.y), animated: false)
        }
        else if contentOffset.x <= 0.0 {
            setContentOffset(CGPoint(x: 0.0, y: contentOffset.y), animated: false)
        }
        
        if currentOrigin.x < scrollView.contentOffset.x {
            scrollDirection = .Right
        }
        else {
            scrollDirection = .Left
        }
        
        calculateApproachingPage()
        animateAlphaViews()
        fixSubviews()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        var page = 1
        for origin in pageOrigins {
            if scrollView.contentOffset.x == origin.x {
                currentPage = page - 1
                break
            }
            page += 1
        }
        pagingIndicator.currentPage = currentPage
        currentOrigin = pageOrigins[currentPage]
        pagingIndicator.updateCurrentPageDisplay()
    }
}
