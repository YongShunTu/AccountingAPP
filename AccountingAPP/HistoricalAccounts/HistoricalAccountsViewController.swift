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
    @IBOutlet weak var selectLhsdatePickerView: UIPickerView!
    @IBOutlet weak var selectRhsdatePickerView: UIPickerView!
    @IBOutlet weak var selectLhsdateButton: UIButton!
    @IBOutlet weak var selectRhsdateButton: UIButton!
    @IBOutlet weak var selectPickerViewBlockingView: UIView!
    @IBOutlet weak var historicalAccountsSearchBar: UISearchBar!
    @IBOutlet weak var historicalTotalMoneyLabel: UILabel!
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
            findSerchTextInSpecificDateInAccounts(historicalAccountsSearchBar.text ?? "")
            
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
                historicalAccountsTableViewBlockingView.alpha = 1
                historicalTotalMoneyLabel.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificDateInAccountsTatalMoney())) ?? "")"
                historicalAccountsTableView.reloadData()
            }else{
                historicalAccountsTableViewBlockingView.alpha = 0
                historicalTotalMoneyLabel.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificDateInAccountsTatalMoney())) ?? "")"
                historicalAccountsTableView.reloadData()
            }
        }
    }
    
    var years: [String] = []
    var months: [String] = ["01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月"]
    var days: [String] = []
    
    var currentLhsyearString: String = ""
    var currentLhsmonthString: String = ""
    var currentLhsdayString: String = ""
    var currentLhsdateString: String = "" {
        didSet {
            selectLhsdateButton.setTitle(currentLhsdateString, for: .normal)
            findSerchTextInSpecificDateInAccounts(historicalAccountsSearchBar.text ?? "")
            print("\(days)")
        }
    }
    
    var currentRhsyearString: String = ""
    var currentRhsmonthString: String = ""
    var currentRhsdayString: String = ""
    var currentRhsdateString: String = "" {
        didSet{
            selectRhsdateButton.setTitle(currentRhsdateString, for: .normal)
            findSerchTextInSpecificDateInAccounts(historicalAccountsSearchBar.text ?? "")
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
        fetchDays()
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
    
    func fetchDays() {
        var year = years.first
        var month = months.first
        year?.removeLast()
        month?.removeLast()
        let dateComponents = DateComponents(year: Int(year ?? ""), month: Int(month ?? ""))
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        days.removeAll()
        for i in 1...numDays {
            days.append(String(i) + "日")
        }

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
    
    func fetchSpecificDateInAccounts(_ accounts: [Accounts], _ lhsdateString: String, _ rhsdateString: String) -> [Accounts] {
        let newArray = accounts.filter { accounts in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年MM月dd日"
            let day = dateForMatter.string(from: accounts.date)
            let lhsResult = lhsdateString.compare(day, options: .numeric)
            let rhsResult = rhsdateString.compare(day, options: .numeric)
            if lhsResult != .orderedDescending && rhsResult != .orderedAscending {
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
    
    func calculateSpecificDateInAccountsTatalMoney() -> Double {
        let total = specificDateInAccounts.reduce(0.0) { partialResult, account in
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
            historicalTotalMoneyLabel.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        }else{
            historicalTotalMoneyLabel.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
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
        specificDateInAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historicalAccountsTableView.dequeueReusableCell(withIdentifier: "\(HistoricalAccountsTableViewCell.self)", for: indexPath) as? HistoricalAccountsTableViewCell
        else { return UITableViewCell() }
        
        let account = specificDateInAccounts[indexPath.row]
        
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
            controller.account = specificDateInAccounts[row]
        }
    }
    
}

extension HistoricalAccountsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        case 2:
            return days.count
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
        case 2:
            return days[row]
        default:
            break
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var year = years[pickerView.selectedRow(inComponent: 0)]
        var month = months[pickerView.selectedRow(inComponent: 1)]
        year.removeLast()
        month.removeLast()
        let dateComponents = DateComponents(year: Int(year), month: Int(month))
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        days.removeAll()
        for i in 1...numDays {
            days.append(String(i) + "日")
        }
        selectLhsdatePickerView.reloadAllComponents()
        selectRhsdatePickerView.reloadAllComponents()
    }
    
    
    @IBAction func showLhsdatePickerViewButtonClicked(_ sender: UIButton) {
        if years == [] {
            let alter = UIAlertController(title: "目前無資料喔", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alter.addAction(action)
            present(alter, animated: true, completion: nil)
        }else{
            selectLhsdatePickerView.isHidden = false
            selectRhsdatePickerView.isHidden = true
            showLhsdatePickerView()
        }
    }
    
    @IBAction func showRhsdatePickerViewButtonClicked(_ sender: UIButton) {
        if years == [] {
            let alter = UIAlertController(title: "目前無資料喔", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alter.addAction(action)
            present(alter, animated: true, completion: nil)
        }else{
            selectLhsdatePickerView.isHidden = true
            selectRhsdatePickerView.isHidden = false
            showRhsdatePickerView()
        }
    }
    
    @IBAction func closeDatePickerViewButtonClciked(_ sender: UIButton) {
        closeDatePickerView()
    }
    
    @IBAction func selectDateButtonClicked(_ sender: UIButton) {
        if !selectLhsdatePickerView.isHidden {
            let yearIndex = selectLhsdatePickerView.selectedRow(inComponent: 0)
            let monthIndex = selectLhsdatePickerView.selectedRow(inComponent: 1)
            let dayIndex = selectLhsdatePickerView.selectedRow(inComponent: 2)
            currentLhsyearString = years[yearIndex]
            currentLhsmonthString = months[monthIndex]
            currentLhsdayString = days[dayIndex]
            currentLhsdateString = currentLhsyearString + currentLhsmonthString + currentLhsdayString
        }else if !selectRhsdatePickerView.isHidden {
            let yearIndex = selectRhsdatePickerView.selectedRow(inComponent: 0)
            let monthIndex = selectRhsdatePickerView.selectedRow(inComponent: 1)
            let dayIndex = selectRhsdatePickerView.selectedRow(inComponent: 2)
            currentRhsyearString = years[yearIndex]
            currentRhsmonthString = months[monthIndex]
            currentRhsdayString = days[dayIndex]
            currentRhsdateString = currentRhsyearString + currentRhsmonthString + currentRhsdayString
            
        }
        
        closeDatePickerView()
    }
    
    func showLhsdatePickerView() {
        if let yearIndex = years.firstIndex(of: currentLhsyearString),
           let monthIndex = months.firstIndex(of: currentLhsmonthString),
           let lhsday = days.firstIndex(of: currentLhsdayString)
        {
            self.selectLhsdatePickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            self.selectLhsdatePickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            self.selectLhsdatePickerView.selectRow(lhsday, inComponent: 2, animated: false)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func showRhsdatePickerView() {
        if let yearIndex = years.firstIndex(of: currentRhsyearString),
           let monthIndex = months.firstIndex(of: currentRhsmonthString),
           let rhsday = days.firstIndex(of: currentRhsdayString)
        {
            selectRhsdatePickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            selectRhsdatePickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            selectRhsdatePickerView.selectRow(rhsday, inComponent: 2, animated: false)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func closeDatePickerView() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

extension HistoricalAccountsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findSerchTextInSpecificDateInAccounts(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findSerchTextInSpecificDateInAccounts(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }

    func findSerchTextInSpecificDateInAccounts(_ searchText: String) {
        if searchText.isEmpty == false {
            specificDateInAccounts = fetchSpecificDateInAccounts(accounts, currentLhsdateString, currentRhsdateString).filter({ accounts in
                accounts.subtype.localizedStandardContains(searchText) || accounts.project.localizedStandardContains(searchText) || accounts.note.localizedStandardContains(searchText)
            })
        }else{
            specificDateInAccounts = fetchSpecificDateInAccounts(accounts, currentLhsdateString, currentRhsdateString)
        }
    }
    
}

extension HistoricalAccountsViewController: EditAccountViewControllerDelegate {
    func editAccount(edit account: Accounts) {
        if let row = historicalAccountsTableView.indexPathForSelectedRow?.row {
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
