//
//  ViewController.swift
//  Temp
//
//  Created by Eric Agredo on 12/28/15.
//  Copyright © 2015 Eric. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var spark = TempBrain()
    var myCore : SparkDevice?
    
    @IBOutlet weak var temp: UILabel!

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func updateTemp(){
        
        spark.logIn()
        spark.findDevices()
        
        myCore = spark.myPhoton
        
        
        myCore?.getVariable("temperature", completion: { (result:AnyObject!, error:NSError!) -> Void in
            if let _ = error {
                print("Failed reading temperature from device")
            }
            else {
                if let larry = result as? Float {
                    self.temp.text="\(larry)"
                }
            }
        })
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        updateTemp()
    }
    
    


}

