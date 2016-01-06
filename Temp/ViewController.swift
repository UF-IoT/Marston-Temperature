//
//  ViewController.swift
//  Temp
//
//  Created by Eric Agredo on 12/28/15.
//  Copyright © 2015 Eric. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
   /* Variables   */
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var  myPhoton : SparkDevice?
    var truth = 0 //A tracker to see if a value has been retrieved from the cloud, which means stop the acvtivity indicator.
    @IBOutlet weak var temp: UILabel!
    
    
    //This was to make the status bar white and visible since the background is black
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
   /*
   This function serves to log the Particle Core into the server and to find the device.
   The activity variable is to give the app a spinning wheel indicator while the values loaded.
    These functions were basically given in the Spark SDK but I tweaked it a bit.
*/
    func sparkStart(){
        
        activity.startAnimating()
    
        SparkCloud.sharedInstance().loginWithUser("ericagredo@gmail.com", password: "seljak12") { (error:NSError!) -> Void in
            if let _=error {
                print("Wrong credentials or no internet connectivity, please try again")
            }
            else {
                print("Logged in")
            }
        }
        
        
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]!, error:NSError!) -> Void in
            if let _ = error {
                print("Check your internet connectivity")
            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    for device in devices {
                        if device.name == "Erics_Core" {
                            self.myPhoton = device
                            
                            print("Connected to Device")
                        }
                    }
                }
            }
        }
        
    }
    
    //Once we have the device logged in, we can now retreive the varible from the cloud.
    
    func updateTemp(){
        
        
     /*Since it takes  time for the Core to log in, we execute getting the variable 3 seconds after the
        the code starts running. This way, the result of the tempF variable isn't nil.
*/
        let seconds = 3.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            
            
            
            
            
            self.myPhoton?.getVariable("tempF", completion: { (result:AnyObject!, error:NSError!) -> Void in
                if let _ = error {
                    print("Failed reading temperature from device")
                }
                else {
                    if let larry = result as? Int {
                       
                        
                        self.temp.text="\(larry)˚"
                        self.truth++ //Once a value has been found, update the count.
                    }
                }
            })

            
            
            
        })
        
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        sparkStart()
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        updateTemp()
        
        NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "updateTemp", userInfo: nil, repeats: true) //Gaurantees that the app is updated every 100 seconds. That way we have a fresh temperature often.
        
        //Stop the spinning once a value has been found
        if truth == 1{
            activity.stopAnimating()
            activity.removeFromSuperview()
        }
        
        
    }
    
   
    


}

