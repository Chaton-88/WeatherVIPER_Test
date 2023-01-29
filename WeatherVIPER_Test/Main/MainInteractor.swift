//
//  MainInteractor.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 07.01.2023.
//

import Foundation
import UIKit
import CoreData

protocol MainInteractorProtocol: AnyObject {
    func loadWeather(for city: String)
    func loadWeather(forCoordinate: String, coordinate: String)
    func loadSaveData()
}

final class MainInteractor: MainInteractorProtocol {
    
    weak var  presenter: MainPresenterProtocol?
    private let networkDataFetcher: NetworkDataFetcher
    private let locationService: LocationService
    private let databaseManager: DataBaseManager
    
    init(networkDataFetcher: NetworkDataFetcher, locationService: LocationService, databaseManager: DataBaseManager) {
        self.networkDataFetcher = networkDataFetcher
        self.locationService = locationService
        self.databaseManager = databaseManager
    }
   
    func loadWeather(for city: String) {
        locationService.getCoordinateFrom(address: city, completion: { [weak self] (coordinate) in
            guard let coordinate = coordinate else { return }
            let latitude = coordinate.latitude.description
            let longitude = coordinate.longitude.description
            
            self?.networkDataFetcher.fetchCities(latitude: latitude, longitude: longitude, completion: { [weak self] (response) in
                let city = response?[0].name
                let temps = response?.map { $0.main.temp }
                let date = response?[0].dt.getDateStringFromUTC()
                self?.databaseManager.saveWeather(city: city!, tempF: temps![0], tempC: temps![1], date: date!)
                
                self?.presenter?.didLoad(city: city, temp: temps)
            })
        })
    }
    
    func loadWeather(forCoordinate: String, coordinate: String) {
        self.networkDataFetcher.fetchCities(latitude: forCoordinate, longitude: coordinate) {[weak self] (response) in
            let city = response?[0].name
            let temps = response?.map { $0.main.temp }
            
            self?.presenter?.didLoadLocation(city: city, temp: temps)
        }
    }
    
    func loadSaveData() {
        let dataWeather = self.databaseManager.getWeather()
        self.presenter?.upcoming(data: dataWeather)
    }
}
