//
//  SearchResults.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 06.01.2023.
//

import Foundation

struct SearchResults: Decodable {
    let main: MainInfo
    let name: String
    let dt: Double
}

struct MainInfo: Decodable {
    let temp: Double
}
