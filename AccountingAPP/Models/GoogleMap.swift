//
//  GoogleMap.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/20.
//

import Foundation

struct GoogleMapResponse: Codable {
    let results: [Results]
}

struct Results: Codable {
    let name: String
    let vicinity: String
}
