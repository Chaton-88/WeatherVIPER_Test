//
//  DataBaseManager.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 28.01.2023.
//

import Foundation
import CoreData

class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let persistenContainer: NSPersistentContainer
    
    init() {
        let container = NSPersistentContainer(name: "DataBaseModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistem stores: \(error)")
            }
        }
        self.persistenContainer = container
    }
    
    func saveWeather(city: String, tempF: Double, tempC: Double ,date: String) {
        
        do {
            if let weatherData = NSEntityDescription.insertNewObject(forEntityName: "WeatherData", into: persistenContainer.viewContext) as? WeatherData {
                weatherData.name = city
                weatherData.tempF = tempF
                weatherData.tempC = tempC
                weatherData.date = date
            } else {
                fatalError("Unable to insert WeatherData entity")
            }
            
            try persistenContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func getWeather() -> [WeatherResult] {
        let featchRequest = WeatherData.fetchRequest()
        var weatherItems: [WeatherResult] = []
        
        do {
            let weather = try persistenContainer.viewContext.fetch(featchRequest)
            for weather in weather {
                let weatherResult = WeatherResult(name: weather.name ?? "", tempC: weather.tempC, tempF: weather.tempF, date: weather.date ?? "")
                weatherItems.append(weatherResult)
            }
            return weatherItems
        } catch let error {
            print(error.localizedDescription)
        }
        return weatherItems
    }
}

