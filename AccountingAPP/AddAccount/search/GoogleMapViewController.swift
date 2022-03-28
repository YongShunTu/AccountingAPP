//
//  GoogleMapViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/19.
//

import UIKit
import CoreLocation

protocol GoogleMapViewControllerDelegate {
    func getLocation(_ location: String)
}

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var listActivity: UIActivityIndicatorView!
    @IBOutlet weak var listSearchBar: UISearchBar!

    var location: String = ""

    let locationManager = CLLocationManager()
    
    var lists = [Results]()
    var searchBarLabel: String?
    var googleDelegate: GoogleMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
//
//        // 定位的精準度
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        // 取得定位
//        locationManager.requestLocation()
        // Do any additional setup after loading the view.
        listSearchBar.text = searchBarLabel
        listActivity.isHidden = true

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = nil
        let currentLocation = locations.first!
        location = "\(String(currentLocation.coordinate.latitude)),\(String(currentLocation.coordinate.longitude))"
        GoogleMapController.shard.fetchNearLocation(location, keyWord: searchBarLabel ?? "" ) { (results) in
            switch results {
            case .success(let results):
                DispatchQueue.main.async {
                    self.updateList(results)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        print("Current location: \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)\n\(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func updateList(_ lists: [Results]) {
        DispatchQueue.main.async {
            self.lists = lists
            self.listTableView.reloadData()
            self.listActivity.isHidden = true
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GoogleMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "\(GoogleMapTableViewCell.self)", for: indexPath) as? GoogleMapTableViewCell else
        { return UITableViewCell() }
        
        let list = lists[indexPath.row]
        cell.nameLabel.text = list.name
        cell.addressLabel.text = list.vicinity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        googleDelegate?.getLocation(lists[indexPath.row].name)
        dismiss(animated: true, completion: nil)
    }
    
}

extension GoogleMapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        listActivity.isHidden = false
        searchBarLabel = searchText
        GoogleMapController.shard.fetchNearLocation(location, keyWord: searchBarLabel ?? "") { (results) in
            switch results {
            case .success(let results):
                DispatchQueue.main.async {
                    self.updateList(results)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
 
}
