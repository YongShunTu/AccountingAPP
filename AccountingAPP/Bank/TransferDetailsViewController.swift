//
//  TransferDetailsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/14.
//

import UIKit

class TransferDetailsViewController: UIViewController {
    
    @IBOutlet weak var selectedYearAndMonthPickerView: UIPickerView!
    @IBOutlet weak var selectedYearAndMonthButton: UIButton!
    @IBOutlet weak var selectPickerViewBlockingView: UIView!
    @IBOutlet weak var transferDetailsTableView: UITableView!
    @IBOutlet weak var transferDetailsSearchBar: UISearchBar!
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
        }
    }
    
    var bankAccounts = [BankAccounts]() {
        didSet {
            print("test\(bankAccounts)")
            BankAccounts.saveBank(bankAccounts)
            specificMonthBankAccounts = fetchSpecificMonthInBankAccounts(bankAccounts, yearAndMonthString)
        }
    }
    
    var specificMonthBankAccounts = [BankAccounts]()
    {
        didSet {
            print("\(specificMonthBankAccounts)")
            if specificMonthBankAccounts.count == 0 {
                transferDetailsTableView.alpha = 0
                transferDetailsTableView.reloadData()
            }else{
                transferDetailsTableView.alpha = 1
                transferDetailsTableView.reloadData()
            }
        }
    }
    
    var years: [String] = []
    var months: [String] = ["01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月"]
    var currentYearString: String = ""
    var currentMonthString: String = ""
    var yearAndMonthString: String = "" {
        didSet {
            selectedYearAndMonthButton.setTitle(yearAndMonthString, for: .normal)
            //            specificDateInAccounts = accounts
            specificMonthBankAccounts = fetchSpecificMonthInBankAccounts(self.bankAccounts, yearAndMonthString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectPickerViewBlockingView.alpha = 0
        if let bankAccounts = BankAccounts.loadBank() {
            self.bankAccounts = bankAccounts
        }
        
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
        }
        
        transferDetailsSearchBar.addKeyboardReturn()
        updateBankAccountsSequence()
        fetchYearAccounts()
        selectedYearAndMonthPickerView.reloadAllComponents()
        
    }
    
    func fetchYearAccounts() {
        let yearMonth = self.bankAccounts.reduce(into: [String:Int]()) { (counts, accounts) in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let date = dateForMatter.string(from: accounts.date)
            counts[date, default: 1] += 0
        }
        years = yearMonth.keys.sorted(by: >)
    }
    
    func fetchSpecificMonthInBankAccounts(_ accounts: [BankAccounts], _ date: String) -> [BankAccounts] {
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
    
    func updateBankAccountsSequence() {
        self.bankAccounts = bankAccounts.sorted(by: { lhs, rhs in
            let lhsTime = lhs.date
            let rhsTime = rhs.date
            return lhsTime > rhsTime
        })
    }
    
    func findIndexInAccounts(_ indexInBankAccounts: BankAccounts) -> Int? {
        for (index, account) in self.accounts.enumerated() {
            if account.date == indexInBankAccounts.date {
                return index
            }
        }
        return nil
    }
    
    func findIndexInBankAccounts(_ indexInBankAccounts: BankAccounts) -> Int {
        for (index, bankAccount) in self.bankAccounts.enumerated() {
            if bankAccount.date == indexInBankAccounts.date {
                return index
            }
        }
        return 0
    }
    
    @IBAction func dismissDetailBankAccountsView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

extension TransferDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificMonthBankAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = transferDetailsTableView.dequeueReusableCell(withIdentifier: "\(BankDetailTableViewCell.self)", for: indexPath) as? BankDetailTableViewCell else
        { return UITableViewCell() }
        
        let bankAccount = specificMonthBankAccounts[indexPath.row]
        cell.bankDetailNameLabel.text = "\(bankAccount.transferOutName) -> \(bankAccount.transferInName)"
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy/MM/dd"
        let day = dateForMatter.string(from: bankAccount.date)
        cell.bankDetailDate.text = day
        cell.bankDetailNote.text = "備註:\(bankAccount.note)"
        cell.bankDetailMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: bankAccount.transferInMoney)) ?? ""
        cell.bankDetailPhoto.image = UIImage(named: bankAccount.transferOutName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditTransferDetailsViewController,
           let row = transferDetailsTableView.indexPathForSelectedRow?.row
        {
            controller.bankAccount = specificMonthBankAccounts[row]
            controller.delegate = self
        }
    }
    
}

extension TransferDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        let yearIndex = selectedYearAndMonthPickerView.selectedRow(inComponent: 0)
        let monthIndex = selectedYearAndMonthPickerView.selectedRow(inComponent: 1)
        currentYearString = years[yearIndex]
        currentMonthString = months[monthIndex]
        yearAndMonthString = currentYearString + currentMonthString
        closeYearAndMonthPickerView()
    }
    
    func showYearAndMonthPickerView() {
        if let yearIndex = years.firstIndex(of: currentYearString),
           let monthIndex = months.firstIndex(of: currentMonthString) {
            self.selectedYearAndMonthPickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            self.selectedYearAndMonthPickerView.selectRow(monthIndex, inComponent: 1, animated: false)
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

extension TransferDetailsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            specificMonthBankAccounts = bankAccounts.filter ({ bankAccounts in
                bankAccounts.transferOutName.localizedStandardContains(searchText)
            })
        }else{
            specificMonthBankAccounts = bankAccounts
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        transferDetailsSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension TransferDetailsViewController: EditTransferDetailsViewControllerDelegate {
    func editTransferDetails(_ bankAcoount: BankAccounts, _ account: Accounts, handlingFee: Double) {
        if let row = transferDetailsTableView.indexPathForSelectedRow?.row {
            let bankAccountIndex = findIndexInBankAccounts(specificMonthBankAccounts[row])
            
            if let accountIndex = findIndexInAccounts(specificMonthBankAccounts[row]) {
                if handlingFee != 0 {
                    accounts[accountIndex] = account
                }else{
                    accounts.remove(at: accountIndex)
                }
            }else{
                if handlingFee != 0 {
                    accounts.insert(account, at: 0)
                }else{
                    
                }
            }
            
            bankAccounts[bankAccountIndex] = bankAcoount
            updateBankAccountsSequence()
        }
        
    }
    
    func deleteTransferDetails(_ bankAccount: BankAccounts) {
        bankAccounts.remove(at: findIndexInBankAccounts(bankAccount))
        if let index = findIndexInAccounts(bankAccount) {
            accounts.remove(at: index)
        }
    }
    
    
}
