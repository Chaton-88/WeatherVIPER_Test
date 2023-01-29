//
//  MainModuleBilder.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 07.01.2023.
//

import UIKit

final class MainModuleBilder {
    static func build() -> ViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let locationService = LocationService()
        let databaseManager = DataBaseManager()
        
        let interactor = MainInteractor(networkDataFetcher: networkDataFetcher, locationService: locationService, databaseManager: databaseManager)
        let router = MainRouter()
        let presenter = MainPresenter(router: router, interactor: interactor)
        let viewController = ViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
