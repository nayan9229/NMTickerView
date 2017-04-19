//
//  Tickercell.swift
//  NMTickerView
//
//  Created by nayan on 10/09/16.
//  Copyright © 2016 vishavatech. All rights reserved.
//

import UIKit

class NMTickerCell: UIView {

    var cellview : UIView!
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var diffrent: UILabel!
    @IBOutlet weak var diffrentInpercentage: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        initialization()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NMTickerCell", bundle: bundle)
        cellview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        cellview.frame = bounds
//        cellview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(cellview);
    }
    
    func initialization() {
        self.titleText.text = "TICKETS"
        self.value.text = "29998"
        self.diffrent.text = "+20"
        self.diffrentInpercentage.text = "+4%"
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64(NSEC_PER_SEC) * 1)), dispatch_get_main_queue(), { () -> Void in
//        })
    }
    func setData(data : NSDictionary)  {
//        self.value.text = "\(position)"
//        ["name":randomString(Int(arc4random_uniform(UInt32(10))))]
//        dict["value"] = "\(Int(arc4random_uniform(UInt32(1000))))"
//        dict["diff"] = "\(Int(arc4random_uniform(UInt32(100))))"
//        dict["diffper"]
        self.value.text = data["value"] as? String
        self.titleText.text = data["name"] as? String
        self.diffrent.text = data["diff"] as? String
        self.diffrentInpercentage.text = data["diffper"] as? String
    }

}
