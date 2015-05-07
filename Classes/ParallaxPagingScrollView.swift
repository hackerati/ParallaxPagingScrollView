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
    private var pageOrigins = Array<CGPoint>()
    private var currentPage: Int = 0
    private var currentOrigin = CGPoint(x: 0.0, y: 0.0)
    private var childrenViews = Dictionary<ParallaxViewType, Array<ParallaxScrollViewSubviewModel>>()
    private var scrollDirection = ScrollDirection.Left
    
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
        
        for page in 0..<numberOfPages {
            let pageOriginX = frame.size.width * CGFloat(page)
            pageOrigins.append(CGPoint(x: pageOriginX, y: frame.origin.y))
        }
        
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
        pagingIndicator.hidden = !self.pagingEnabled
        self.addSubview(pagingIndicator)
    }
    
    private func trackView(subviewModel: ParallaxScrollViewSubviewModel, type: ParallaxViewType)
    {
        if var viewArray = childrenViews[type] {
            viewArray.append(subviewModel)
            childrenViews[type] = viewArray
        }
        else {
            var newArray = [subviewModel]
            childrenViews[type] = newArray
        }
    }
    
    private func animateAlphaViews(contentOffset: CGPoint)
    {
        if let alphaViews = childrenViews[.AlphaEffect] {
            
            for viewModel in alphaViews {
                
                if self.canApplyEffectToView(viewModel) {
                    
                    let pageWidth = self.frame.size.width
                    if let pageNumber = viewModel.pageNumber {
                        let newAlpha = ((pageWidth * CGFloat(pageNumber + 1)) - contentOffset.x) / pageWidth
                        viewModel.view.alpha = newAlpha
                    }
                }
            }
        }
    }
    
    private func fixSubviews()
    {
        if let fixedSubviews = childrenViews[.FixedEffect] {
            
            for viewModel in fixedSubviews {
                
                if self.canApplyEffectToView(viewModel) {
                    var fixedFrame = viewModel.view.frame
                    fixedFrame.origin.x = contentOffset.x
                    viewModel.view.frame = fixedFrame
                }
            }
        }
    }
    
    private func canApplyEffectToView(viewModel: ParallaxScrollViewSubviewModel) -> Bool
    {
        if let pageNumber = viewModel.pageNumber {
            
            if pageNumber == currentPage {
                if scrollDirection == .Left { // if going backwards
                    return false
                }
                else {
                    return true
                }
            }
            else if scrollDirection == .Left && pageNumber == currentPage - 1 {
                return true
            }
        }
        else {
            
            // Handle special case for effects with page ranges
            if let (lowerBound, upperBound) = viewModel.pageRange {
                let approachingPage = self.approachingPage();
                if approachingPage >= lowerBound - 1 && approachingPage < upperBound - 1 {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func newViewRect(originalRect: CGRect, pageNumber: Int) -> CGRect
    {
        let pageOrigin = pageOrigins[pageNumber - 1]
        let newOriginX = originalRect.origin.x + pageOrigin.x
        return CGRect(origin: CGPoint(x: newOriginX, y: originalRect.origin.y), size: originalRect.size)
    }
    
    private func approachingPage() -> Int
    {
        var approachingPage = 0;
        if scrollDirection == .Left {
            approachingPage = currentPage - 1
        }
        else {
            approachingPage = currentPage
        }
        return approachingPage
    }
    
    private func addSubview(view: UIView, page: Int)
    {
        assert(page > 0, "Page number can not be 0 or negative")
        assert(page <= pageOrigins.count, "Page number exceeds the amount of pages in the scroll view")
        
        view.frame = self.newViewRect(view.frame, pageNumber: page)
        self.addSubview(view)
    }
    
    // MARK: Public
    
    func addSubview(view: UIView, type: ParallaxViewType, page: Int)
    {
        self.addSubview(view, page: page)
        
        let subviewModel = ParallaxScrollViewSubviewModel(view: view, type: type, pageNumber: page - 1)
        self.trackView(subviewModel, type: type)
    }
    
    func addFixedSubview(view: UIView, pageSpan:(Int, Int))
    {
        let (lowerBound, upperBound) = pageSpan
        assert(lowerBound < upperBound, "Page range must go in ascending order")
        assert(lowerBound > 0 && upperBound <= numberOfPages, "Page range out of bounds of number of pages")
        
        self.addSubview(view, page: lowerBound)
        
        let subviewModel = ParallaxScrollViewSubviewModel(view: view, type: .FixedEffect, pageRange: pageSpan)
        self.trackView(subviewModel, type: .FixedEffect)
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if pagingEnabled {
            var fixedFrame = pagingIndicator.frame
            fixedFrame.origin.x = scrollView.contentOffset.x
            pagingIndicator.frame = fixedFrame
        }
        
        if currentOrigin.x < scrollView.contentOffset.x {
            scrollDirection = .Right
        }
        else {
            scrollDirection = .Left
        }
        
        self.animateAlphaViews(scrollView.contentOffset)
        self.fixSubviews()
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
