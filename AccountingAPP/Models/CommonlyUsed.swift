//
//  CommonlyUsed.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/18.
//

import Foundation

//struct CommonlyUsedAccount: Codable {
//    let expenditrueOrIncome: String
//    let money: String
//    let tittle: String
//    let category: String
//    let subtype: String
//    let note: String
//    let project: String
//    let location: String
//
//    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    static func loadCommonAccounts() -> [Self]? {
//        let url = documentDirectory.appendingPathComponent("commonAccounts")
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        let decoder = JSONDecoder()
//        return try? decoder.decode([CommonlyUsedAccount].self, from: data)
//    }
//
//    static func saveCommonAccounts(_ commonAccounts: [Self]) {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(commonAccounts) else { return }
//        let url = documentDirectory.appendingPathComponent("commonAccounts")
//        try? data.write(to: url)
//    }
//}
//
//struct CommonlyUsedIncome: Codable {
//    let expenditrueOrIncome: String
//    let money: String
//    let tittle: String
//    let category: String
//    let subtype: String
//    let note: String
//    let project: String
//    let location: String
//
//    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    static func loadCommonAccounts() -> [Self]? {
//        let url = documentDirectory.appendingPathComponent("CommonlyUsedIncome")
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        let decoder = JSONDecoder()
//        return try? decoder.decode([CommonlyUsedIncome].self, from: data)
//    }
//
//    static func saveCommonAccounts(_ commonAccounts: [Self]) {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(commonAccounts) else { return }
//        let url = documentDirectory.appendingPathComponent("CommonlyUsedIncome")
//        try? data.write(to: url)
//    }
//}
//
//struct CommonlyUsedExpenditure: Codable {
//    let expenditrueOrIncome: String
//    let money: String
//    let tittle: String
//    let category: String
//    let subtype: String
//    let note: String
//    let project: String
//    let location: String
//
//    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//    static func loadCommonAccounts() -> [Self]? {
//        let url = documentDirectory.appendingPathComponent("CommonlyUsedExpenditure")
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        let decoder = JSONDecoder()
//        return try? decoder.decode([CommonlyUsedExpenditure].self, from: data)
//    }
//
//    static func saveCommonAccounts(_ commonAccounts: [Self]) {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(commonAccounts) else { return }
//        let url = documentDirectory.appendingPathComponent("CommonlyUsedExpenditure")
//        try? data.write(to: url)
//    }
//}
