//
//  ViewController.swift
//  Ascent Prototype
//
//  Created by Dan Fairbanks on 10/26/15.
//  Copyright © 2015 Fairbanksdan. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let altimeter = CMAltimeter()
    var data : CMAltitudeData? = CMAltitudeData()
    var error : NSError?
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var elapsedTime = NSTimeInterval()
    var minutes = UInt8()
    var strMinutes = String()
    var elapsedTimeInterval = Double()
    
    @IBOutlet weak var relativeAltitudeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateOfAscentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        elapsedTime = currentTime - startTime
        elapsedTimeInterval = elapsedTime
        print("elapsedTime is \(elapsedTimeInterval)")
        minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
//        let fraction = UInt8(elapsedTime * 100)
        strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
//        let strFraction = String(format: "%02d", fraction)
        timeLabel.text = "\(strMinutes):\(strSeconds)"
    }

    @IBAction func startButtonPressed(sender: UIButton) {
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                if error == nil {
                    let formatter = NSNumberFormatter()
                    formatter.numberStyle = .DecimalStyle
                    var relativeAltitude = formatter.stringFromNumber((data?.relativeAltitude)!)
                    self.relativeAltitudeLabel.text = relativeAltitude
                    
                    var relativeAltitudeDouble = data?.relativeAltitude.doubleValue
                    
                    let rateOfAscentString = formatter.stringFromNumber(relativeAltitudeDouble! / (self.elapsedTimeInterval / 60.0))
                    
                    self.rateOfAscentLabel.text = rateOfAscentString
                }
            })
        }
        
    }


}

