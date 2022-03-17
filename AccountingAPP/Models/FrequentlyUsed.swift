//
//  FrequentlyUsed.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import Foundation

struct FrequentlyUsedIncome: Codable {
    let expenditrueOrIncome: String
    let money: Double
    let tittle: String
    let category: String
    let subtype: String
    let note: String
    let project: String
    let location: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadFrequentlyUsedIncome() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("frequentlyUsedIncome")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([FrequentlyUsedIncome].self, from: data)
    }
    
    static func saveFrequentlyUsedIncome(_ frequentlyUsedIncome: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(frequentlyUsedIncome) else { return }
        let url = documentDirectory.appendingPathComponent("frequentlyUsedIncome")
        try? data.write(to: url)
    }
}

struct FrequentlyUsedExpenditure: Codable {
    let expenditrueOrIncome: String
    let money: Double
    let tittle: String
    let category: String
    let subtype: String
    let note: String
    let project: String
    let location: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadFrequentlyUsedExpenditure() -> [Self]? {
        let url = documentDirectory.appendingPathComponent("FrequentlyUsedExpenditure")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([FrequentlyUsedExpenditure].self, from: data)
    }
    
    static func saveFrequentlyUsedExpenditure(_ frequentlyUsedExpenditure: [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(frequentlyUsedExpenditure) else { return }
        let url = documentDirectory.appendingPathComponent("FrequentlyUsedExpenditure")
        try? data.write(to: url)
    }
}
