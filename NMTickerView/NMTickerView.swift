//
//  Ticker.swift
//  NMTickerView
//
//  Created by nayan on 08/09/16.
//  Copyright © 2016 vishavatech. All rights reserved.
//

import UIKit

//protocol NMTickerViewDataSource {
//    func numberOfItems(tickerView : NMTickerView) -> Int
//    func dataForItemAtIndex(tickerView : NMTickerView, index: Int) -> NSDictionary
//}

class NMTickerView: UIScrollView, UIScrollViewDelegate {

    let NMCELL_WIDTH : CGFloat = 150
    
//    var delegateT: NMTickerViewDataSource?
    
    var data: NSArray!
    
    private var cells: [NMTickerCell] = []
    private var cellContainerView: UIView
    var index : Int = 0
    
    var scTimer : NSTimer!
    
    override init(frame: CGRect) {
        self.cellContainerView = UIView()
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cellContainerView = UIView()
        super.init(coder: aDecoder)
        initialization()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.recenterIfNecessary()
        
//        CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
//        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
//        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        
        let visibleBounds : CGRect = self.convertRect(self.bounds, toView: self.cellContainerView)
        let minimumVisibleX : CGFloat = CGRectGetMinX(visibleBounds)
        let maximumVisibleX : CGFloat = CGRectGetMaxX(visibleBounds)
        self.tileLabelsFromMinX(minimumVisibleX, toMaxX: maximumVisibleX)
    }
    
    func initialization()  {
        self.layoutIfNeeded()
        
        self.bounces = false
        self.scrollEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.contentSize = CGSizeMake(5000, 50)
        
        self.cellContainerView.frame = CGRectMake(0, 5, self.contentSize.width, self.contentSize.height)
        self.addSubview(self.cellContainerView)
        self.cellContainerView.userInteractionEnabled = false
    }
    
//    func setTickerData(data: NSArray) {
//        self.data = data
//        for i in 0 ..< 5 {
//            let cell = NMTickerCell(frame: CGRectMake(CGFloat(i*150), 5, 150, 50))
//            cells.append(cell)
//            self.addSubview(cell)
//        }
//    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scroll \(scrollView.contentOffset)")
    }
    
    func reloadData()  {
        self.recenterIfNecessary()
        
        let visibleBounds : CGRect = self.convertRect(self.bounds, toView: self.cellContainerView)
        let minimumVisibleX : CGFloat = CGRectGetMinX(visibleBounds)
        let maximumVisibleX : CGFloat = CGRectGetMaxX(visibleBounds)
        self.tileLabelsFromMinX(minimumVisibleX, toMaxX: maximumVisibleX)
    }
    
    func startScrolling()  {
//        UIView.animateWithDuration(0.2, animations: {
//            self.contentOffset = CGPointMake(self.contentOffset.x+10, 0);
//            }) { (Bool) in
//            self.startScrolling()
//        }
        scTimer = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector:#selector(NMTickerView.onTimer), userInfo: nil, repeats: true)
    }
    
    func stopScrolling()  {
        scTimer.invalidate()
    }
    
    func onTimer() {
//        UIView.animateWithDuration(0.5) {
//            self.contentOffset = CGPointMake(self.contentOffset.x+10, 0);
//        }
//        self.contentOffset = CGPointMake(self.contentOffset.x+2, 0);
        self.setContentOffset(CGPointMake(self.contentOffset.x+20, 0), animated: true)
    }
    
    func setTickerData(data : NSArray)  {
        self.data = data;
    }
    
    private func insertLabel(position : Int) -> NMTickerCell {
        let cell = NMTickerCell(frame: CGRectMake(CGFloat(NMCELL_WIDTH), 5, 150, 50))
        if self.data != nil{
            cell.setData(self.data.objectAtIndex(index) as! NSDictionary)
            index += 1
            if index >= self.data.count {
                index = 0
            }
            self.cellContainerView.addSubview(cell)
        }
        return cell
    }
    
    
    func recenterIfNecessary()  {
        let currentOffset : CGPoint = self.contentOffset
        let contentWidth : CGFloat = self.contentSize.width
        let centerOffsetX : CGFloat = (contentWidth - self.bounds.size.width)/2.0
        let distanceFromCenter : CGFloat = fabs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter > (contentWidth/4.0) {
            self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y)
            // move content by the same amount so it appears to stay still
            for i : Int in 0  ..< cells.count {
                let cell = cells[i]
                var center : CGPoint = cell.center
                center.x += (centerOffsetX - currentOffset.x)
                cell.center = center
            }
        }
    }
    
    private func placeNewLabelOnRight(rightEdge: CGFloat, position : Int) -> CGFloat {
        let cell = self.insertLabel(position)
        self.cells.append(cell) // add rightmost label at the end of the array
        
        var frame = cell.frame
        frame.origin.x = rightEdge
        frame.origin.y = self.cellContainerView.bounds.size.height - frame.size.height
        cell.frame = frame
        return CGRectGetMaxX(frame)
    }
    
    private func placeNewLabelOnLeft(leftEdge: CGFloat, position : Int) -> CGFloat {
        let cell = self.insertLabel(position)
        self.cells.insert(cell, atIndex: 0) // add leftmost label at the beginning of the array
        
        var frame = cell.frame
        frame.origin.x = leftEdge - frame.size.width
        frame.origin.y = self.cellContainerView.bounds.size.height - frame.size.height
        cell.frame = frame
        
        return CGRectGetMinX(frame)
    }
    
    private func tileLabelsFromMinX(minimumVisibleX: CGFloat, toMaxX maximumVisibleX: CGFloat) {
        // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
        // to kick off the tiling we need to make sure there's at least one label
        if self.cells.isEmpty {
            self.placeNewLabelOnRight(minimumVisibleX, position: 0)
        }
        
        // add labels that are missing on right side
        let lastLabel = self.cells.last!
        var rightEdge = CGRectGetMaxX(lastLabel.frame)
        while rightEdge < maximumVisibleX {
            rightEdge = self.placeNewLabelOnRight(rightEdge, position: 0)
        }
        
        // add labels that are missing on left side
        let firstLabel = self.cells[0]
        var leftEdge = CGRectGetMinX(firstLabel.frame)
        while leftEdge > minimumVisibleX {
            leftEdge = self.placeNewLabelOnLeft(leftEdge, position: 0)
        }
        
        // remove labels that have fallen off right edge
        while let lastLabel = self.cells.last
            where lastLabel.frame.origin.x > maximumVisibleX {
                lastLabel.removeFromSuperview()
                self.cells.removeLast()
        }
        
        // remove labels that have fallen off left edge
        while let firstLabel = self.cells.first
            where CGRectGetMaxX(firstLabel.frame) < minimumVisibleX {
                firstLabel.removeFromSuperview()
                self.cells.removeFirst()
        }
    }
}





