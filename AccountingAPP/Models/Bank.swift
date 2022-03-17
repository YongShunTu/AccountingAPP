//
//  Bank.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/7.
//

import Foundation

struct Bank: Codable {
    let name: String
    let money: Double
    let date: Date
    let note: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadBank() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("bank")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Bank].self, from: data)
    }
    
    static func saveBank(_ bank: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(bank) else { return }
        let url = documentDirectory.appendingPathComponent("bank")
        try? data.write(to: url)
    }
    
}
