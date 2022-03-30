//
//  WeatherManager.swift
//  Clima
//
//  Created by MacBook Pro on 06.10.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,  weatherinput: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9bf0678042f48e5ffabceeaaa35ea42b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
       
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print(urlString)
        
    }
    
    func performRequest (with urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    
                    print(safeData)
                    if let weatherFunc = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weatherinput: weatherFunc)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherdata: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
          let decodedData = try decoder.decode(WeatherData.self, from: weatherdata)
          let id = decodedData.weather[0].id
          let name = decodedData.name
          let temp = decodedData.main.temp
          let speed = decodedData.wind.speed
          
            
            let weather = WeatherModel(conditionId: id, cityname: name, temperature: temp, speed: speed)
            return weather
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
