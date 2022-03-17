//
//  GoogleMapController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/20.
//

import Foundation
import MapKit
import CoreLocation

class GoogleMapController {
    
    let api_Key = "API KEY"
    
    static let shard = GoogleMapController()
    
    func fetchNearLocation(_ location: String, keyWord: String, completion: @escaping (Result<[Results],Error>) -> Void) {
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=10000&keyword=\(keyWord)&language=zh-TW&key=\(api_Key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let GoogleMapResponse = try decoder.decode(GoogleMapResponse.self, from: data)
                        completion(.success(GoogleMapResponse.results))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
    
}
