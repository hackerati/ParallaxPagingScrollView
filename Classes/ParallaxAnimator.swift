//
//  ParallaxAnimator.swift
//  ParallaxPagingScrollView
//
//  Created by Clayton Rieck on 5/7/15.
//  Copyright (c) 2015 The Hackerati. All rights reserved.
//

import Foundation
import UIKit

class ParallaxAnimator : NSObject
{
    private weak var animatorView: ParallaxPagingScrollView!
    private var childrenViews = [ParallaxViewType : [ParallaxScrollViewSubviewModel]]()
    
    init(animatorView: ParallaxPagingScrollView)
    {
        super.init()
        self.animatorView = animatorView
    }
    
    func animateViewsOfType(type: ParallaxViewType)
    {
        
        childrenViews[type]?.filter({self.canApplyEffectToView($0)}).map({$0.animation?()})
       
    }
    
    func trackView(subviewModel: ParallaxScrollViewSubviewModel, type: ParallaxViewType)
    {
        let closure: animationClosure?
        switch type {
            case .AlphaEffect:
                closure = {
                    let pageWidth = self.animatorView.frame.size.width
                    if let pageNumber = subviewModel.pageNumber {
                        let newAlpha = ((pageWidth * CGFloat(pageNumber + 1)) - self.animatorView.contentOffset.x) / pageWidth
                        subviewModel.view.alpha = newAlpha
                    }
                    return
                }
            case .FixedEffect:
                closure = {
                    var fixedFrame = subviewModel.view.frame
                    fixedFrame.origin.x = self.animatorView.contentOffset.x
                    subviewModel.view.frame = fixedFrame
                }
            default:
                closure = nil
                break
        }
        
        subviewModel.animation = closure

        if var viewArray = childrenViews[type] {
            viewArray.append(subviewModel)
            childrenViews[type] = viewArray
        }
        else {
            var newArray = [subviewModel]
            childrenViews[type] = newArray
        }
    }
    
    private func canApplyEffectToView(viewModel: ParallaxScrollViewSubviewModel) -> Bool
    {
        if let pageNumber = viewModel.pageNumber {
            
            if pageNumber == animatorView.currentPage {
                if animatorView.scrollDirection == .Left { // if going backwards
                    return false
                }
                else {
                    return true
                }
            }
            else if animatorView.scrollDirection == .Left && pageNumber == animatorView.currentPage - 1 {
                return true
            }
        }
        else {
            
            // Handle special case for effects with page ranges
            if let (lowerBound, upperBound) = viewModel.pageRange {
                if animatorView.nextPage >= lowerBound - 1 && animatorView.nextPage < upperBound - 1 {
                    return true
                }
            }
        }
        
        return false
    }

}
