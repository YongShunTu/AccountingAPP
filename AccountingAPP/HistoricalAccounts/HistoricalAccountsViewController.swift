//
//  HistoricalAccountsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/24.
//

import UIKit
import Foundation

class HistoricalAccountsViewController: UIViewController {
    
    @IBOutlet weak var historicalAccountsTableView: UITableView!
    @IBOutlet weak var historicalAccountsTableViewBlockingView: UIView!
    @IBOutlet weak var selectYearAndMonthPickerView: UIPickerView!
    @IBOutlet weak var selectYearAndMonthButton: UIButton!
    @IBOutlet weak var selectPickerViewBlockingView: UIView!
    @IBOutlet weak var historicalAccountsSearchBar: UISearchBar!
    @IBOutlet weak var historicalAccountsTotalMoney: UILabel!
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
            findSearchTextInSpecificMonthInAccounts(historicalAccountsSearchBar.text ?? "")
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
    
    var specificMonthInAccounts = [Accounts]() {
        didSet {
            if specificMonthInAccounts.count == 0 {
                historicalAccountsTableViewBlockingView.alpha = 1
                historicalAccountsTotalMoney.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificMonthInAccountsTatalMoney())) ?? "")"
                historicalAccountsTableView.reloadData()
            }else{
                historicalAccountsTableViewBlockingView.alpha = 0
                historicalAccountsTotalMoney.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificMonthInAccountsTatalMoney())) ?? "")"
                historicalAccountsTableView.reloadData()
            }
        }
    }
    
    var years: [String] = []
    let months: [String] = ["01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月"]
    var currentYearString: String = ""
    var currentMonthString: String = ""
    var yearAndMonthString: String = "" {
        didSet {
            selectYearAndMonthButton.setTitle(yearAndMonthString, for: .normal)
            findSearchTextInSpecificMonthInAccounts(historicalAccountsSearchBar.text ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addTapGesture()
        selectPickerViewBlockingView.alpha = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
        }
        
        if let bankAccounts = BankAccounts.loadBank() {
            self.bankAccounts = bankAccounts
        }
        
        if let withdrawalBanks = WithdrawalBanks.loadBank() {
            self.withdrawalBanks = withdrawalBanks
        }
        historicalAccountsSearchBar.addKeyboardReturn()
        updateAccountsSequence()
        fetchYears()
        selectYearAndMonthPickerView.reloadAllComponents()
    }
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func fetchYears() {
        let year = self.accounts.reduce(into: [String:Int]()) { (counts, accounts) in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let date = dateForMatter.string(from: accounts.date)
            counts[date, default: 1] += 0
        }
        years = year.keys.sorted(by: >)
    }
    
    func fetchSpecificMonthInAccounts(_ accounts: [Accounts], _ date: String) -> [Accounts] {
        let newArray = accounts.filter { account in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年MM月"
            let day = dateForMatter.string(from: account.date)
            if day == date {
                return true
            }else{
                return false
            }
        }
        return newArray
    }
    
    func updateAccountsSequence() {
        self.accounts = accounts.sorted { lhs, rhs in
            let lhsTime = lhs.date
            let rhsTime = rhs.date
            return lhsTime > rhsTime
        }
    }
    
    func findIndexInAccounts(_ deleteAccountsInDate: Accounts) -> Int {
        for (index, account) in self.accounts.enumerated() {
            if account.accountsIndex == deleteAccountsInDate.accountsIndex {
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
    
    func calculateSpecificMonthInAccountsTatalMoney() -> Double {
        let total = specificMonthInAccounts.reduce(0.0) { partialResult, account in
            switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
            case .income:
                return partialResult + account.money
            case .expenditure:
                return partialResult - account.money
            default:
                break
            }
            return partialResult
        }
        if total >= 0 {
            historicalAccountsTotalMoney.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        }else{
            historicalAccountsTotalMoney.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
        }
        return total
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

extension HistoricalAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificMonthInAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historicalAccountsTableView.dequeueReusableCell(withIdentifier: "\(HistoricalAccountsTableViewCell.self)", for: indexPath) as? HistoricalAccountsTableViewCell
        else { return UITableViewCell() }
        
        let account = specificMonthInAccounts[indexPath.row]
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy/MM/dd"
        cell.historicalDateLabel.text = dateForMatter.string(from: account.date)
        cell.historicalNoteLabel.text = "備註:\(account.note)"
        
        switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
        case .income:
            cell.historicalSubTyoeLabel.text = account.subtype + "(\(account.project))"
            cell.historicalMoneyLabel.text = "+\(NumberStyle.currencyStyle().string(from: NSNumber(value: account.money))!)"
            cell.historicalMoneyLabel.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        case .expenditure:
            cell.historicalSubTyoeLabel.text = account.subtype
            cell.historicalMoneyLabel.text = "-\(NumberStyle.currencyStyle().string(from: NSNumber(value: account.money))!)"
            cell.historicalMoneyLabel.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
        default:
            break
        }
        
        if let imageName = account.imageName {
            let imageURL = Accounts.documentDirectory.appendingPathComponent(imageName).appendingPathExtension("jpeg")
            cell.historicalPhoto.image = UIImage(contentsOfFile: imageURL.path)
            cell.historicalPhoto.clipsToBounds = true
            cell.historicalPhoto.layer.cornerRadius = 10
        }else{
            cell.historicalPhoto.image = UIImage(named: account.category)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditAccountViewController,
           let row = historicalAccountsTableView.indexPathForSelectedRow?.row {
            controller.delegate = self
            controller.account = specificMonthInAccounts[row]
        }
    }
    
}

extension HistoricalAccountsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return years[row]
        case 1:
            return months[row]
        default:
            break
        }
        return ""
    }
    
    @IBAction func showYearAndMonthPickerViewButtonClicked(_ sender: UIButton) {
        if years == [] {
            let alter = UIAlertController(title: "目前無資料喔", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alter.addAction(action)
            present(alter, animated: true, completion: nil)
        }else{
            showYearAndMonthPickerView()
        }
    }
    
    @IBAction func closeYearAndMonthPickerViewButtonClciked(_ sender: UIButton) {
        closeYearAndMonthPickerView()
    }
    
    @IBAction func selectYearAndMonthButtonClicked(_ sender: UIButton) {
        let yearIndex = selectYearAndMonthPickerView.selectedRow(inComponent: 0)
        let monthIndex = selectYearAndMonthPickerView.selectedRow(inComponent: 1)
        currentYearString = years[yearIndex]
        currentMonthString = months[monthIndex]
        yearAndMonthString = currentYearString + currentMonthString
        closeYearAndMonthPickerView()
    }
    
    func showYearAndMonthPickerView() {
        if let yearIndex = years.firstIndex(of: currentYearString),
           let monthIndex = months.firstIndex(of: currentMonthString) {
            self.selectYearAndMonthPickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            self.selectYearAndMonthPickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeYearAndMonthPickerView() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

extension HistoricalAccountsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findSearchTextInSpecificMonthInAccounts(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findSearchTextInSpecificMonthInAccounts(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func findSearchTextInSpecificMonthInAccounts(_ searchText: String) {
        if searchText.isEmpty == false {
            self.specificMonthInAccounts = fetchSpecificMonthInAccounts(self.accounts, yearAndMonthString).filter ({ accounts in
                accounts.subtype.localizedStandardContains(searchText) || accounts.project.localizedStandardContains(searchText) || accounts.note.localizedStandardContains(searchText)
            })
        }else{
            self.specificMonthInAccounts = fetchSpecificMonthInAccounts(self.accounts, yearAndMonthString)
        }
    }
    
}

extension HistoricalAccountsViewController: EditAccountViewControllerDelegate {
    func editAccount(edit account: Accounts) {
        if let row = historicalAccountsTableView.indexPathForSelectedRow?.row {
            let accountIndex = findIndexInAccounts(specificMonthInAccounts[row])
            if account.subtype == "轉帳手續費" {
                if let bankAccountsIndex = findIndexInBankAccounts(specificMonthInAccounts[row]) {
                    self.bankAccounts[bankAccountsIndex].handlingFee = account.money
                    self.bankAccounts[bankAccountsIndex].transferOutName = account.bankAccounts
                }
            }
            
            if account.subtype == "提款手續費" {
                if let withdrawalBanksIndex = findIndexInWithdrawalBanks(specificMonthInAccounts[row]) {
                    self.withdrawalBanks[withdrawalBanksIndex].handlingFee = account.money
                    self.withdrawalBanks[withdrawalBanksIndex].transferOutName = account.bankAccounts
                }
            }
            
            accounts[accountIndex] = account
            updateAccountsSequence()
        }
    }
    
    func deleteAccount(delete account: Accounts) {
        if account.subtype == "轉帳手續費" {
            if let bankIndex = findIndexInBankAccounts(account) {
                self.bankAccounts[bankIndex].handlingFee = 0
            }
        }
        if account.subtype == "提款手續費"{
            if let withdrawalBanksIndex = findIndexInWithdrawalBanks(account) {
                self.withdrawalBanks[withdrawalBanksIndex].handlingFee = 0
            }
        }
        accounts.remove(at: findIndexInAccounts(account))
    }
    
    
}
