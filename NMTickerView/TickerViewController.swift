//
//  TickerViewController.swift
//  NMTickerView
//
//  Created by nayan on 08/09/16.
//  Copyright © 2016 vishavatech. All rights reserved.
//

import UIKit

class TickerViewController: UIViewController {

    @IBOutlet weak var TickerView: NMTickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var dataArray: [NSDictionary] = []
        
        for _ : Int in 0  ..< 5 {
            var dict = ["name":randomString(Int(arc4random_uniform(UInt32(10))))]
            dict["value"] = "\(Int(arc4random_uniform(UInt32(10000))))"
            dict["diff"] = "\(Int(arc4random_uniform(UInt32(100))))"
            dict["diffper"] = "\(drand48())%"
            dataArray.append(dict)
        }
        TickerView.setTickerData(dataArray)
        TickerView.reloadData()
        TickerView.startScrolling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomString(length: Int) -> String {
        let charactersString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return string
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
