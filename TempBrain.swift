//
//  TempBrain.swift
//  Temp
//
//  Created by Eric Agredo on 12/28/15.
//  Copyright © 2015 Eric. All rights reserved.
//

import Foundation
import UIKit

class TempBrain{
    
    var myPhoton : SparkDevice?
    
    func logIn(){
        
        SparkCloud.sharedInstance().loginWithUser("ericagredo@gmail.com", password: "seljak12") { (error:NSError!) -> Void in
            if let _=error {
                print("Wrong credentials or no internet connectivity, please try again")
            }
            else {
                print("Logged in")
            }
        }
        
        
    }
    
    func findDevices(){
        
        
        
        
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]!, error:NSError!) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    for device in devices {
                        if device.name == "myNewPhotonName" {
                            self.myPhoton = device
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
}

