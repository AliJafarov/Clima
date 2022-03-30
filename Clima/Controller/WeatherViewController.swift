//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var speedLabel: UILabel!
    
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
    
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text == "" {
            searchTextField.placeholder = "Type something"
            }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let city = searchTextField.text
        weatherManager.fetchWeather(cityName: city!)
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
   
    func didUpdateWeather(_ weatherManager: WeatherManager,  weatherinput: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherinput.temperatureString
            self.speedLabel.text = weatherinput.speedString
            self.conditionImageView.image = UIImage(systemName: weatherinput.conditionName)
            self.cityLabel.text = weatherinput.cityname
        }
    }
    
    func didFailWithError(error: Error){
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

