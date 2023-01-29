//
//  NetworkService.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 06.01.2023.
//

import Foundation
import UIKit

final class NetworkService {
    
    func request(latitude: String, longitude: String, completion: @escaping ([URLRequest]) -> Void) {
        
        let paramFirst = self.prepareParams(latitude: latitude, longitude: longitude, param: "metric")
        let paramSecond = self.prepareParams(latitude: latitude, longitude: longitude, param: "imperial")
        
        let urlFirst = self.url(params: paramFirst)
        let urlSecond = self.url(params: paramSecond)
        
        let requestFirst = URLRequest(url: urlFirst)
        let requestSecond = URLRequest(url: urlSecond)
        
        let requests = [requestFirst, requestSecond]
        completion(requests)
    }
    
    private func prepareParams(latitude: String?, longitude: String?, param: String) -> [String: String] {
        var params = [String: String]()
        params["lat"] = latitude
        params["lon"] = longitude
        params["appid"] = "492a5c455137b3f6bbdb0034f07cb191"
        params["units"] = param
        
        return params
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
       
        return components.url!
    }
}

