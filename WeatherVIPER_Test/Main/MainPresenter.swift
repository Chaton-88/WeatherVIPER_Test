//
//  MainPresenter.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 07.01.2023.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func startLoadingSaveData()
    func startLoadingInfo(for city: String)
    func startLoadingLocation(coordinateLatitude: String, coordinateLongitude: String)
    func didLoad(city: String?, temp: [Double]?)
    func didLoadLocation(city: String?, temp: [Double]?)
    func upcoming(data: [WeatherResult]?)
}

final class MainPresenter {
    
    weak var view: MainViewProtocol?
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol
    
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func startLoadingSaveData() {
        interactor.loadSaveData()
    }
    
    func startLoadingInfo(for city: String) {
        interactor.loadWeather(for: city)
    }
    
    func  startLoadingLocation(coordinateLatitude: String, coordinateLongitude: String) {
        interactor.loadWeather(forCoordinate: coordinateLatitude, coordinate: coordinateLongitude)
    }
    
    func didLoad(city: String?, temp: [Double]?) {
        guard let temp = temp else { return }
        view?.showWeather(city: city ?? "No city", temp: temp)
    }
    
    func didLoad(color: String?) {
        view?.showBackground(withColor: color ?? "")
    }
    
    func didLoadLocation(city: String?, temp: [Double]?) {
        guard let temp = temp else { return }
        view?.showWeatherLocation(city: city ?? "No city", temp: temp)
    }
    
    func upcoming(data: [WeatherResult]?) {
        view?.showDisplayData(data: data ?? [])
    }
}
