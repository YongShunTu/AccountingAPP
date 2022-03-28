//
//  Expenditure.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/12.
//

import Foundation
import UIKit

struct Accounts: Codable {
    let expenditureOrIncome: String
    let imageName: String?
    let money: Double
    let date: Date
    let category: String
    let subtype: String
    let note: String
    let bankAccounts: String
    let project: String
    let location: String
    let accountsIndex: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadAccount() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("account")
        guard let data = try? Data(contentsOf: url) else { return nil }
            let decoder = JSONDecoder()
        return try? decoder.decode([Accounts].self, from: data)
    }
    
    static func saveAccount(_ accounts: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(accounts) else { return }
        let url = documentDirectory.appendingPathComponent("account")
        try? data.write(to: url)
        }
    
    }

