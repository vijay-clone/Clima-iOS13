//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate ,WeatherManagerDelegate{
    
   
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
     var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
         let cityName = searchTextField.text!
         searchTextField.endEditing(true)
         weatherManager.getUrlWithName(name: cityName)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cityName = searchTextField.text!
        searchTextField.endEditing(true)
        weatherManager.getUrlWithName(name: cityName)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        }else{
            textField.placeholder = "Please Enter A City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func didFailWithError(error: Error) {
           print(error)
       }
       
       func didUpdateValue(weather:WeatherModel) {
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.tempratureString
               self.cityLabel.text = weather.cityName
               let imageName = weather.conditionName
               self.conditionImageView.image = UIImage(systemName: imageName)
           }
           
       }
      
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               locationManager.stopUpdatingLocation()
               let lat = location.coordinate.latitude
               let lon = location.coordinate.longitude
               weatherManager.getUrlWithCoordinates(latitude: lat, longitude: lon)
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error")
       }
        
}

