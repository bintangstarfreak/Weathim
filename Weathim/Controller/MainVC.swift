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
import ProgressHUD //cara buka cocoapod ke folder tujuan install pod via terminal sebelum itu copas ke podfile

class MainVC: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    func changeCity(city: String) {
        let params: [String:String] = ["q": city, "appid": APP_ID]
        getWeather(url: API_URL, parameters: params)
    }
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperaturLabel: UILabel!
    @IBOutlet weak var minTemperaturLabel: UILabel!
    @IBOutlet weak var maxTemperaturLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    let locationManager = CLLocationManager()
    let API_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "897976f11c469feb5cd774276cc34980"
    let weatherDataModel = WeatherModel()
    
    
    //override itu tampilan awal load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        changeBG()
        
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
        ProgressHUD.show("Some text...")
        AF.request(API_URL, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .success(let value):
                ProgressHUD.dismiss()
                let json = JSON(value!)
                self.assignData(data: json)
                print("JSON \(json)")
            case .failure(let error):
                ProgressHUD.dismiss()
                print("ERROR \(error)")
            }
            
        }
    }
    
    func assignData(data: JSON) {
        weatherDataModel.temperature = Int(data["main"]["temp"].doubleValue - 273.15) //merubah celcius jadi kelvin -273
        weatherDataModel.city = data["name"].stringValue
        weatherDataModel.condition = data["weather"][0]["id"].intValue
        weatherDataModel.weatherIcon = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        weatherDataModel.tempMin = Int (data["main"]["temp_min"].doubleValue - 273.15)
        weatherDataModel.tempMax = Int (data["main"]["temp_min"].doubleValue - 273.15)
        weatherDataModel.conditionName = data["weather"][0]["main"].stringValue
        updateViews()
    }
    
    func updateViews() {
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIcon)
        cityLabel.text = weatherDataModel.city
        temperaturLabel.text = "\(weatherDataModel.temperature)"
        minTemperaturLabel.text = "MIN: \(weatherDataModel.tempMin) ℃"
        maxTemperaturLabel.text = "MAX: \(weatherDataModel.tempMax) ℃"
        dateLabel.text = getDate()
        
    }
    
    func getDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        let timeString = formatter.string(from: currentDateTime)
        return timeString
    }
    
    func changeBG() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 0 && hour < 17 {
            backgroundImgView.image = #imageLiteral(resourceName: "dayBG")
        } else {
            backgroundImgView.image = #imageLiteral(resourceName: "nightBG")
        }
    }
    
    //manggil data ke depan
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationVC = segue.destination as! SettingsVC
            destinationVC.delegate = self
        }
    }
    
    
    
    @IBAction func unwindToMainVC(unwindSegue: UIStoryboardSegue)  {
        
    }
}

