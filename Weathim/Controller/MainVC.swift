//
//  ViewController.swift
//  Weathim
//
//  Created by Bintang Aria Ramadhan on 17/03/21.
//  Copyright © 2021 Starfreak. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MainVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperaturLabel: UILabel!
    @IBOutlet weak var minTemperaturLabel: UILabel!
    @IBOutlet weak var maxTemperaturLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let API_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "897976f11c469feb5cd774276cc34980"
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeather(url: API_URL, parameters: params)
        }
    }
    
    func getWeather(url: String, parameters: [String:String]) {
        
    }


}

