//
//  WeatherManager.swift
//  Clima
//
//  Created by Vijay Vikram Singh on 02/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate{
    func didUpdateValue(weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    var delegate:WeatherManagerDelegate?
    let parentUrl = "https://api.openweathermap.org/data/2.5/weather?appid=bd3748d6f29c01cb24703d524e7eca37&units=metric"
    
    func getUrlWithName(name:String){
        let searchUrl = "\(parentUrl)&q=\(name)"
        getWeatherData(searchUrl: searchUrl)
    }
    func getUrlWithCoordinates(latitude: Double, longitude: Double){
        let searchUrl = "\(parentUrl)&lat=\(latitude)&lon=\(longitude)"
        getWeatherData(searchUrl: searchUrl)
    }
    func getWeatherData(searchUrl: String){
        
        let url = URL(string: searchUrl)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
            }
            
            if let safeData = data {
                if let weather = self.parseJSON(data: safeData){
                    self.delegate?.didUpdateValue(weather: weather)
                }
                
            }
        }
        task.resume()
    }
    
    func parseJSON (data:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let cityName = decodedData.name
            let temprature = decodedData.main.temp
            let climateId = decodedData.weather[0].id
            let weather = WeatherModel(conditionId: climateId, cityName: cityName, temprature: temprature)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
