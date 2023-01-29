//
//  Double.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 28.01.2023.
//

import Foundation

extension Double {
    
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
}
