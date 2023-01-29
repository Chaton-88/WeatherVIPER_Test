//
//  ViewController.swift
//  WeatherVIPER_Test
//
//  Created by Valeriya Trofimova on 06.01.2023.
//

import UIKit
import CoreLocation

protocol MainViewProtocol: AnyObject {
    func showWeather(city: String, temp: [Double])
    func showBackground(withColor: String)
    func showWeatherLocation(city: String, temp: [Double])
    func showDisplayData(data: [WeatherResult])
}

final class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    
    var presenter: MainPresenterProtocol?
    private let locationService = LocationService()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellId = "cellId"
    
    private lazy var barButtonItem: UIBarButtonItem = {
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "location.north.circle"), for: .normal)
        button.addTarget(self, action: #selector(barButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    private var isIncluded = false
    private var dataProperty: [WeatherResult]?
    private var dataSourceCity: String?
    private var dataSourceTemp: [Double]?
    private var color: String?
    private var dataSourceLocationCity: String?
    private var dataSourceLocationTemp: [Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Weather"
        
        setupTableView()
        setupSearchBar()
        setupNavBar()
        locationService.locationAuthorization(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.startLoadingSaveData()
    }
    
    // MARK: - Setup views
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.reuseIdentifer)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Setup search bar
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City name"
    }
    
    //MARK: - Setup navigation bar
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // MARK: - NavigationItems Action
    @objc private func barButtonTapped() {
        dataSourceCity = dataSourceLocationCity
        dataSourceTemp = dataSourceLocationTemp
        self.reloadEntries()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            guard dataSourceCity != nil else { return 0 }
            return 1
        case 1:
            return dataProperty?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifer, for: indexPath) as! WeatherTableViewCell
            
            cell.cityName.text = dataSourceCity
            
            if isIncluded {
                let temp = dataSourceTemp?.min()
                cell.tempName.text = temp?.description
                cell.backgroundColor = gettingColor(temperatura: temp)
            } else {
                let temp = dataSourceTemp?.max()
                cell.tempName.text = temp?.description
                cell.backgroundColor = gettingColor(temperatura: temp)
            }
            
            cell.tempSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
            let dataWeather = dataProperty?[indexPath.row]
            
            if isIncluded {
                cell.textLabel?.text = "\(dataWeather?.name.description ?? ""), \(Int(dataWeather?.tempC ?? 0).description) C"
            } else {
                cell.textLabel?.text = "\(dataWeather?.name.description ?? ""), \(Int(dataWeather?.tempF ?? 0).description) F"
            }
            cell.detailTextLabel?.text = "\(dataWeather?.date ?? "")"
            return cell
        }
    }
    
    @objc func switchAction(sender: UISwitch) {
        if sender.isOn {
            isIncluded = true
            self.reloadEntries()
        } else {
            isIncluded = false
            self.reloadEntries()
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] (_) in
            self?.presenter?.startLoadingInfo(for: searchText)
        })
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let latitude = lastLocation.coordinate.latitude.description
        let longitude = lastLocation.coordinate.longitude.description
        self.presenter?.startLoadingLocation(coordinateLatitude: latitude, coordinateLongitude: longitude)
    }
}

// MARK: - MainViewProtocol
extension ViewController: MainViewProtocol {
    
    func showWeather(city: String, temp: [Double]) {
        self.dataSourceCity = city
        self.dataSourceTemp = temp
        self.reloadEntries()
    }
    
    func showBackground(withColor: String) {
        self.color = withColor
        self.reloadEntries()
    }
    
    func showWeatherLocation(city: String, temp: [Double]) {
        self.dataSourceLocationCity = city
        self.dataSourceLocationTemp = temp
        self.reloadEntries()
    }
    
    func showDisplayData(data: [WeatherResult]) {
        dataProperty = data
        reloadEntries()
    }
}

extension ViewController {
    
    func reloadEntries() {
        tableView.reloadData()
    }
    
    func gettingColor(temperatura: Double?) -> (UIColor?) {
        var color = UIColor.white
        if let temp = temperatura {
            if temp < 10.0 {
                color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            } else if temp >= 10.0 && temp <= 25.0 {
                color = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            } else if temp > 25.0 {
                color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        return color
    }
}
