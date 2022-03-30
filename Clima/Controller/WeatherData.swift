//
//  WeatherData.swift
//  Clima
//
//  Created by MacBook Pro on 07.10.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
