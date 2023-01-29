//
//  WeatherTableViewCell.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 07.01.2023.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    static var reuseIdentifer = "weather-cell-identifier"
    let cityName = UILabel(font: .avenirNextDemiBold20())
    let tempName = UILabel(font: .avenirNext14())
    private let farengateLabel = UILabel(text: "F", font: .avenirNext14())
    private let celsiusLabel = UILabel(text: "C", font: .avenirNext14())
    
    let tempSwitch: UISwitch = {
        let tempSwitch = UISwitch()
        tempSwitch.toAutoLayout()
        tempSwitch.onTintColor = .lightGray
        return tempSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set constraints
    private func setConstraints() {
        
        contentView.addSubview(cityName)
        cityName.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            cityName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
        
        contentView.addSubview(tempName)
        tempName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            tempName.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 15),
            tempName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tempName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
        ])
        
        contentView.addSubview(tempSwitch)
        NSLayoutConstraint.activate([
            tempSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            tempSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
        ])
        
        contentView.addSubview(farengateLabel)
        NSLayoutConstraint.activate([
            farengateLabel.trailingAnchor.constraint(equalTo: tempSwitch.leadingAnchor, constant: -5),
            farengateLabel.bottomAnchor.constraint(equalTo: tempSwitch.bottomAnchor)
        ])
        
        contentView.addSubview(celsiusLabel)
        NSLayoutConstraint.activate([
            celsiusLabel.leadingAnchor.constraint(equalTo: tempSwitch.trailingAnchor, constant: 5),
            celsiusLabel.bottomAnchor.constraint(equalTo: tempSwitch.bottomAnchor)
        ])
    }
}
