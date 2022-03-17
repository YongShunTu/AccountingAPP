//
//  BankAccountsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/7.
//

import UIKit

class BankAccountsViewController: UIViewController {
    
    @IBOutlet weak var bankAccountsTableView: UITableView!
    @IBOutlet weak var allBankAccountsTotalMoney: UILabel!
    
    var accounts = [Accounts]()
//        didSet {
//            bankAccountsTableView.reloadData()
//        }
//    }
    
    var bankAccounts = [BankAccounts]()
//        didSet {
//            BankAccounts.saveBank(bankAccounts)
//            bankAccountsTableView.reloadData()
//        }
//    }
    
    var withdrawalBanks = [WithdrawalBanks]()
    
    var bankInitialMoney = [BankInitialMoney]() {
        didSet {
            BankInitialMoney.saveBank(bankInitialMoney)
            bankAccountsTableView.reloadData()
            print("\(bankInitialMoney)")
        }
    }
    
    var specificBankAccountsMoney: [String: Double] = [:]
    
    var specificBankInitialMoney: [String: Double] = [:]
    
    var specificAccountsMoney: [String: Double] = [:]
    
    var specificWithdrawalBanksMoney: [String: Double] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        NotificationCenter.default.addObserver(self, selector: #selector(updateBankAccounts), name: TransferMoneyViewController.transferMoneyNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bankAccounts = BankAccounts.loadBank() {
            self.bankAccounts = bankAccounts
            print("test \(bankInitialMoney)")
        }
        
        if let bankInitialMoney = BankInitialMoney.loadBank() {
            self.bankInitialMoney = bankInitialMoney
        }
        
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
        }
        
        if let withdrawalBanks = WithdrawalBanks.loadBank() {
            self.withdrawalBanks = withdrawalBanks
        }
        calculateSpecificBankAccountsMoney()
        allBankAccountsTotalMoney.text = "波奇淨資產\n\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateAllBankAccountsTotalMoney())) ?? "")"
        bankAccountsTableView.reloadData()
    }
    
    //    @objc func updateBankAccounts(_ noti: Notification) {
    //        if let user = noti.userInfo,
    //           let bankAccount = user[TransferMoneyViewController.transferMoneyNotificationKey] as? BankAccounts {
    //            bankAccounts.insert(bankAccount, at: 0)
    ////            updateBankAccountsSequence()
    //            print("testBankAccounts")
    //        }
    //    }
    
    //    func updateBankAccountsSequence() {
    //        self.bankAccounts = bankAccounts.sorted(by: { lhs, rhs in
    //            let lhsTime = lhs.date
    //            let rhsTime = rhs.date
    //            return lhsTime > rhsTime
    //        })
    //    }
    
    func calculateSpecificBankAccountsMoney() {
        let accounts = self.accounts.reduce(into: [String: Double]()) { counts, accounts in
            switch ExpenditureOrIncome.init(rawValue: accounts.expenditureOrIncome) {
            case .income:
                counts[accounts.bankAccounts, default: 0] += accounts.money
            case .expenditure:
                counts[accounts.bankAccounts, default: 0] -= accounts.money
            default:
                break
            }
        }
        
        let bankAccounts = self.bankAccounts.reduce(into: [String: Double]() ) { counts, bankAccounts in
            counts[bankAccounts.transferInName, default: 0] += (bankAccounts.transferInMoney)
            counts[bankAccounts.transferOutName, default: 0] -= (bankAccounts.transferOutmoney)
        }
        
        let bankInitialMoney = self.bankInitialMoney.reduce(into: [String: Double]() ) { counts, bankInitialMoney in
            counts[bankInitialMoney.name, default: 0] += bankInitialMoney.money
        }
        
        let withdrawalBanks = self.withdrawalBanks.reduce(into: [String: Double]()) { counts, withdrawalBanks in
            counts[withdrawalBanks.transferOutName, default: 0] -= withdrawalBanks.transferOutMoney
        }
        
        self.specificAccountsMoney = accounts
        self.specificBankInitialMoney = bankInitialMoney
        self.specificBankAccountsMoney = bankAccounts
        self.specificWithdrawalBanksMoney = withdrawalBanks
    }
    
    func calculateAllBankAccountsTotalMoney() -> Double {
        let accountsTotalMoney = self.specificAccountsMoney.reduce(0.0) { partialResult, accounts in
            return partialResult + accounts.value
        }
        let bankAccountsTotalMoney = self.specificBankAccountsMoney.reduce(0.0) { partialResult, bankAccounts in
            return partialResult + bankAccounts.value
        }
        
        let bankInitialTotalMoney = self.specificBankInitialMoney.reduce(0.0) { partialResult, bankInitialMoney in
            return partialResult + bankInitialMoney.value
        }
        
        let withdrawalBanksTotalMoney = self.specificWithdrawalBanksMoney.reduce(0.0) { partialResult, withdrawalBanks in
            return partialResult + withdrawalBanks.value
        }
        
        return accountsTotalMoney + bankAccountsTotalMoney + bankInitialTotalMoney + withdrawalBanksTotalMoney
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



extension BankAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bankItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bankAccountsTableView.dequeueReusableCell(withIdentifier: "\(BankAccountsTableViewCell.self)", for: indexPath) as? BankAccountsTableViewCell else
        { return UITableViewCell() }
        let bankItem = bankItems[indexPath.row]
        cell.bankTitleLabel.text = bankItem
        let accountsMoney = specificAccountsMoney[bankItem] ?? 0.0
        let bankAccountsMoney = specificBankAccountsMoney[bankItem] ?? 0.0
        let bankInitialMoney = specificBankInitialMoney[bankItem] ?? 0.0
        let withdrawalBanksMoney = specificWithdrawalBanksMoney[bankItem] ?? 0.0
        let total = accountsMoney + bankAccountsMoney + bankInitialMoney + withdrawalBanksMoney
        cell.bankInitialMoneyLabel.text = "初始金額:\(NumberStyle.currencyStyle().string(from: NSNumber(value: bankInitialMoney)) ?? "")"
        cell.bankMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: total))
        cell.bankPhoto.image = UIImage(named: bankItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alter = UIAlertController(title: "功能選項", message: nil, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Close", style: .default) { action in
            self.bankAccountsTableView.reloadData()
        }
        
        let transferDetailsAction = UIAlertAction(title: "顯示轉帳明細", style: .default) { action in
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(TransferDetailsViewController.self)") as? TransferDetailsViewController {
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
        
        let withdrawalDetailsAction = UIAlertAction(title: "顯示提款明細", style: .default) { action in
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(WithdrawalDetailsViewController.self)") as? WithdrawalDetailsViewController {
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
        
        let initialMonyAction = UIAlertAction(title: "設定初始金額", style: .default) { action in
            let alter = UIAlertController(title: "帳戶選擇", message: nil, preferredStyle: .alert)
            for (index, value) in bankItems.enumerated() {
                let bankAction = UIAlertAction(title: value, style: .default) { action in
                    let alter = UIAlertController(title: "編輯\(value)初始金額", message: nil, preferredStyle: .alert)
                    alter.addTextField { textField in
                        textField.keyboardType = .numberPad
                        textField.addKeyboardReturn()
                        textField.placeholder = "金額"
                        textField.text = "0"
                    }
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { action in
                        let bankNmae = bankItems[index]
                        let initial = Double(alter.textFields?[0].text ?? "") ?? 0.0
                        
                        self.bankInitialMoney = [
                            BankInitialMoney(name: "\(bankItems[0])", money: self.specificBankInitialMoney[bankItems[0]] ?? 0.0),
                            BankInitialMoney(name: "\(bankItems[1])", money: self.specificBankInitialMoney[bankItems[1]] ?? 0.0),
                            BankInitialMoney(name: "\(bankItems[2])", money: self.specificBankInitialMoney[bankItems[2]] ?? 0.0)
                        ]
                        
                        self.bankInitialMoney[index] = BankInitialMoney(name: bankNmae, money: initial)
                        self.calculateSpecificBankAccountsMoney()
                        self.allBankAccountsTotalMoney.text = "波奇淨資產\n\(NumberStyle.currencyStyle().string(from: NSNumber(value: self.calculateAllBankAccountsTotalMoney())) ?? "")"
                    }
                    let cancleAction = UIAlertAction(title: "cancle", style: .default, handler: nil)
                    
                    alter.addAction(cancleAction)
                    alter.addAction(okAction)
                    self.showDetailViewController(alter, sender: nil)
                }
                alter.addAction(bankAction)
                self.showDetailViewController(alter, sender: nil)
            }
        }
        
        alter.addAction(transferDetailsAction)
        alter.addAction(withdrawalDetailsAction)
        alter.addAction(initialMonyAction)
        alter.addAction(cancleAction)
        present(alter, animated: true, completion: nil)
    }
    
}
