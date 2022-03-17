//
//  BankAccounts.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/7.
//

import Foundation

struct BankAccounts: Codable {
    var transferOutName: String
    let transferInName: String
    let transferOutmoney: Double
    let transferInMoney: Double
    var handlingFee: Double
    let date: Date
    let note: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadBank() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("bankAccounts")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([BankAccounts].self, from: data)
    }
    
    static func saveBank(_ bank: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(bank) else { return }
        let url = documentDirectory.appendingPathComponent("bankAccounts")
        try? data.write(to: url)
    }
    
}

struct BankInitialMoney: Codable {
    let name: String
    let money: Double
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadBank() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("bankInitialMoney")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([BankInitialMoney].self, from: data)
    }
    
    static func saveBank(_ bank: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(bank) else { return }
        let url = documentDirectory.appendingPathComponent("bankInitialMoney")
        try? data.write(to: url)
    }
    
}

struct WithdrawalBanks: Codable {
    let money: Double
    var handlingFee: Double
    var transferOutName: String
    var transferOutMoney: Double
    var date: Date
    let note: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadBank() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("withdrawalBanks")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([WithdrawalBanks].self, from: data)
    }
    
    static func saveBank(_ bank: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(bank) else { return }
        let url = documentDirectory.appendingPathComponent("withdrawalBanks")
        try? data.write(to: url)
    }
}
