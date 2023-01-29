//
//  NetworkDataFetcher.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 06.01.2023.
//

import Foundation

final class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    func fetchCities(latitude: String, longitude: String, completion: @escaping ([SearchResults]?) -> ()) {
        networkService.request(latitude: latitude, longitude: longitude) { requests in
            var results: [SearchResults]? = []
            let urlDownloadGroup = DispatchGroup()
            let urlDownloadQueue = DispatchQueue(label: "com.urlDownloader")
            
            requests.forEach { (request) in
                urlDownloadGroup.enter()
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    guard let data = data,
                          let decode = self.decodeJSON(type: SearchResults.self, from: data) else {
                        if let error = error {
                            print("Error received requesting data: \(error.localizedDescription)")
                        }
                        urlDownloadQueue.async {
                            urlDownloadGroup.leave()
                        }
                        return
                    }
                    urlDownloadQueue.async {
                        results?.append(decode)
                        urlDownloadGroup.leave()
                    }
                }.resume()
            }
            
            urlDownloadGroup.notify(queue: .main) {
                completion(results)
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch let jsonError {
            print("Failed to decode JSON, \(jsonError)")
            return nil
        }
    }
}
