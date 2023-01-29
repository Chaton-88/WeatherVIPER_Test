//
//  WeatherResult.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 28.01.2023.
//

import Foundation

struct WeatherResult {
    var name: String
    var tempC: Double
    var tempF: Double
    var date: String
    
    init(name: String, tempC: Double, tempF: Double, date: String) {
        self.name = name
        self.tempC = tempC
        self.tempF = tempF
        self.date = date
    }
}
