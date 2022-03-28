//
//  ViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/11.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
    
    static let addAccountNotification = Notification.Name("addAccount")
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var mainTableViewBlockingView: UIView!
    @IBOutlet weak var today: UIDatePicker!
    @IBOutlet weak var incomeThisMonth: UILabel!
    @IBOutlet weak var expenditureThisMonth: UILabel!
    @IBOutlet weak var balanceThisMonth: UILabel!
    
    var income: Double = 0.0
    var expenditure: Double = 0.0
    var total: Double = 0.0
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
            specificDateInAccounts = fetchSpecificDateInAccounts(self.accounts, today.date)
            showMoneyInThisMonth(date: today.date)
        }
    }
    
    var bankAccounts = [BankAccounts]() {
        didSet {
            BankAccounts.saveBank(bankAccounts)
        }
    }
    
    var withdrawalBanks = [WithdrawalBanks]() {
        didSet {
            WithdrawalBanks.saveBank(withdrawalBanks)
        }
    }
    
    var specificDateInAccounts = [Accounts]() {
        didSet {
            if specificDateInAccounts.count == 0 {
                mainTableViewBlockingView.alpha = 1
                mainTableView.reloadData()
            }else{
                mainTableViewBlockingView.alpha = 0
                mainTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let account = Accounts.loadAccount() {
            self.accounts = account
            updateAccountsSequence()
            print("\(Accounts.documentDirectory.appendingPathComponent("account").path)")
        }
        
        if let bankAccounts = BankAccounts.loadBank() {
            self.bankAccounts = bankAccounts
        }
        
        if let withdrawalBanks = WithdrawalBanks.loadBank() {
            self.withdrawalBanks = withdrawalBanks
        }
    }
    
    //    @IBAction func unwindToMainViewController(_ unwindSegue: UIStoryboardSegue) {
    //
    //        if let controller = unwindSegue.source as? AddExpenditureViewController,
    //           let account = controller.account {
    //            accounts.insert(account, at: 0)
    //            updateAccountsSequence()
    //        }else if let controller = unwindSegue.source as? AddIncomeViewController,
    //                 let account = controller.account {
    //            accounts.insert(account, at: 0)
    //            updateAccountsSequence()
    //        }
    //
    //    }
    
    func updateAccountsSequence() {
        self.accounts = accounts.sorted { lhs, rhs in
            let lhsTime = lhs.date
            let rhsTime = rhs.date
            return lhsTime > rhsTime
        }
    }
    
    
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        specificDateInAccounts = fetchSpecificDateInAccounts(self.accounts, sender.date)
        showMoneyInThisMonth(date: sender.date)
        print("\(specificDateInAccounts)")
    }
    
    func showMoneyInThisMonth(date: Date) {
        income = calculateThisMonthMoney(.income, date: date)
        expenditure = calculateThisMonthMoney(.expenditure, date: date)
        total = income - expenditure
        incomeThisMonth.text = NumberStyle.currencyStyle().string(from: NSNumber(value: income))
        expenditureThisMonth.text = NumberStyle.currencyStyle().string(from: NSNumber(value: expenditure))
        balanceThisMonth.text = NumberStyle.currencyStyle().string(from: NSNumber(value: (income - expenditure)))
    }
    
    func calculateThisMonthMoney(_ expenditureOrIncome: ExpenditureOrIncome, date: Date) -> Double {
        let newArray = self.accounts.filter { (account) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM"
            let day = dateFormatter.string(from: account.date)
            let month = dateFormatter.string(from: date)
            if day == month && account.expenditureOrIncome == expenditureOrIncome.rawValue {
                return true
            }
            return false
        }
        
        let total = newArray.reduce(0.0) { partialResult, account in
            return partialResult + account.money
        }

        return total
    }

    
    
    func fetchSpecificDateInAccounts(_ accounts: [Accounts], _ date: Date) -> [Accounts] {
        let newArray = accounts.filter { account in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy/MM/dd"
            let day = dateForMatter.string(from: account.date)
            let today = dateForMatter.string(from: date)
            if day == today {
                return true
            }else{
                return false
            }
            
        }
        return newArray
    }
    
    func findIndexInAccounts(_ indexDate: Accounts) -> Int {
        for (index, account) in self.accounts.enumerated() {
            if account.accountsIndex == indexDate.accountsIndex {
                return index
            }
        }
        return 0
    }
    
    func findIndexInBankAccounts(_ indexDate: Accounts) -> Int? {
        for (index, bankAccount) in self.bankAccounts.enumerated() {
            if bankAccount.bankAccountsIndex == indexDate.accountsIndex {
                return index
            }
        }
        return nil
    }
    
    func findIndexInWithdrawalBanks(_ indexDate: Accounts) -> Int? {
        for (index, withdrawalBank) in self.withdrawalBanks.enumerated() {
            if withdrawalBank.withdrawalBanksIndex == indexDate.accountsIndex {
                return index
            }
        }
        return nil
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificDateInAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "\(MainTableViewCell.self)", for: indexPath) as? MainTableViewCell else
        { return UITableViewCell() }
        
        let account = specificDateInAccounts[indexPath.row]
        let dateFotMatter = DateFormatter()
        dateFotMatter.dateFormat = "yyyy/MM/dd"
        let day = dateFotMatter.string(from: account.date)
        cell.dateLabel.text = day
        
        
        switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
        case .expenditure:
            cell.subTypeLabel.text = account.subtype
            cell.moneyLabel.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
            cell.moneyLabel.text = "-\(NumberStyle.currencyStyle().string(from: NSNumber(value: account.money))!)"
        case .income:
            cell.subTypeLabel.text = account.subtype + "(\(account.project))"
            cell.moneyLabel.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
            cell.moneyLabel.text = "+\(NumberStyle.currencyStyle().string(from: NSNumber(value: account.money))!)"
        default:
            break
        }
        
        
        if let imageName = account.imageName {
            let imageURL = Accounts.documentDirectory.appendingPathComponent(imageName).appendingPathExtension("jpeg")
            cell.mainPhoto.image = UIImage(contentsOfFile: imageURL.path)
            cell.mainPhoto.clipsToBounds = true
            cell.mainPhoto.layer.cornerRadius = 10
        }else{
            cell.mainPhoto.image = UIImage(named: account.category)
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditAccountViewController,
           let row = mainTableView.indexPathForSelectedRow?.row {
            controller.delegate = self
            controller.account = self.specificDateInAccounts[row]
        }
        
        if segue.destination is AddAccountViewController {
            AddAccountViewController.addAccountDelegate = self
            AddAccountViewController.selectedDate = today.date
        }
    }
    
    
}

extension MainViewController: EditAccountViewControllerDelegate, AddAccountViewControllerDelegate {
    
    func addIncomeAccount(_ account: Accounts) {
        self.accounts.insert(account, at: 0)
        updateAccountsSequence()
    }
    
    func addExpenditureAccount(_ account: Accounts) {
        self.accounts.insert(account, at: 0)
        updateAccountsSequence()
    }

    func addWithdrawMoneyHandlingFee(_ account: Accounts, withdrawalBank: WithdrawalBanks, handlingFee: Double) {
        if handlingFee != 0.0 {
            self.accounts.insert(account, at: 0)
            self.withdrawalBanks.insert(withdrawalBank, at: 0)
            updateAccountsSequence()
        }else{
            self.withdrawalBanks.insert(withdrawalBank, at: 0)
        }
    }
    
    func addTransferMoneyHandlingFee(_ account: Accounts, bankAccount: BankAccounts, handlingFee: Double) {
        if handlingFee != 0.0 {
            self.accounts.insert(account, at: 0)
            self.bankAccounts.insert(bankAccount, at: 0)
            updateAccountsSequence()
        }else{
            self.bankAccounts.insert(bankAccount, at: 0)
        }
    }
    
    func editAccount(edit account: Accounts) {
        if let row = mainTableView.indexPathForSelectedRow?.row {
            let accountIndex = findIndexInAccounts(specificDateInAccounts[row])
            if account.subtype == "轉帳手續費" {
                if let bankAccountsIndex = findIndexInBankAccounts(specificDateInAccounts[row]) {
                    self.bankAccounts[bankAccountsIndex].handlingFee = account.money
                    self.bankAccounts[bankAccountsIndex].transferOutName = account.bankAccounts
                }
            }
            if account.subtype == "提款手續費" {
                if let withdrawalBanksIndex = findIndexInWithdrawalBanks(specificDateInAccounts[row]) {
                    self.withdrawalBanks[withdrawalBanksIndex].handlingFee = account.money
                    self.withdrawalBanks[withdrawalBanksIndex].transferOutName = account.bankAccounts
                }
            }
            
            self.accounts[accountIndex] = account
            updateAccountsSequence()
        }
        
    }
    
    func deleteAccount(delete account: Accounts) {
        if account.subtype == "轉帳手續費" {
            if let bankAccountsIndex = findIndexInBankAccounts(account) {
                self.bankAccounts[bankAccountsIndex].handlingFee = 0
            }
        }
        if account.subtype == "提款手續費" {
            if let withdrawalBanksIndex = findIndexInWithdrawalBanks(account) {
                self.withdrawalBanks[withdrawalBanksIndex].handlingFee = 0
            }
        }
        
        self.accounts.remove(at: findIndexInAccounts(account))
    }
    
}


