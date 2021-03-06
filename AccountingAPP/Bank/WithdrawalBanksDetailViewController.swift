//
//  WithdrawalBanksDetailViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/15.
//

import UIKit

class WithdrawalBanksDetailViewController: UIViewController {

    @IBOutlet weak var selectedYearAndMonthPickerView: UIPickerView!
    @IBOutlet weak var selectedYearAndMonthButton: UIButton!
    @IBOutlet weak var yearAndMonthBlockingView: UIView!
    @IBOutlet weak var withdrawDetailsTableView: UITableView!
    @IBOutlet weak var withdrawDetailsSearchBar: UISearchBar!
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
        }
    }
    
    var withdrawalBanks = [WithdrawalBanks]() {
        didSet {
            print("test\(withdrawalBanks)")
            WithdrawalBanks.saveBank(withdrawalBanks)
            specificMonthWithdrawalBanks = fetchSpecificMonthInBankAccounts(withdrawalBanks, yearAndMonthString)
        }
    }
    
    var specificMonthWithdrawalBanks = [WithdrawalBanks]()
    {
        didSet {
            print("\(specificMonthWithdrawalBanks)")
            if specificMonthWithdrawalBanks.count == 0 {
                withdrawDetailsTableView.alpha = 0
                withdrawDetailsTableView.reloadData()
            }else{
                withdrawDetailsTableView.alpha = 1
                withdrawDetailsTableView.reloadData()
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
            specificMonthWithdrawalBanks = fetchSpecificMonthInBankAccounts(self.withdrawalBanks, yearAndMonthString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        yearAndMonthBlockingView.alpha = 0
        if let bankAccounts = WithdrawalBanks.loadBank(),
           let accounts = Accounts.loadAccount()
        {
            self.accounts = accounts
            self.withdrawalBanks = bankAccounts
            updateWithdrawalBanksSequence()
            fetchYearAccounts()
            selectedYearAndMonthPickerView.reloadAllComponents()
        }
    }
    
    func fetchYearAccounts() {
        let yearMonth = self.withdrawalBanks.reduce(into: [String:Int]()) { (counts, accounts) in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let date = dateForMatter.string(from: accounts.date)
            counts[date, default: 1] += 0
        }
        years = yearMonth.keys.sorted(by: >)
    }
    
    func fetchSpecificMonthInBankAccounts(_ accounts: [WithdrawalBanks], _ date: String) -> [WithdrawalBanks] {
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
    
    func updateWithdrawalBanksSequence() {
        self.withdrawalBanks = withdrawalBanks.sorted(by: { lhs, rhs in
            let lhsTime = lhs.date
            let rhsTime = rhs.date
            return lhsTime > rhsTime
        })
    }
    
    func findIndexInAccounts(_ indexInBankAccounts: WithdrawalBanks) -> Int? {
        for (index, account) in self.accounts.enumerated() {
            if account.date == indexInBankAccounts.date {
                return index
            }
        }
        return nil
    }
    
    func findIndexInWithdrawalBanks(_ indexInBankAccounts: WithdrawalBanks) -> Int {
        for (index, bankAccount) in self.withdrawalBanks.enumerated() {
            if bankAccount.date == indexInBankAccounts.date {
                return index
            }
        }
        return 0
    }
    
    @IBAction func dismissWithdrawalBanksView(_ sender: UIButton) {
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

extension WithdrawalBanksDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificMonthWithdrawalBanks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = withdrawDetailsTableView.dequeueReusableCell(withIdentifier: "\(TransferDetailsTableViewCell.self)", for: indexPath) as? TransferDetailsTableViewCell else
        { return UITableViewCell() }
        
        let bankAccount = specificMonthWithdrawalBanks[indexPath.row]
        cell.transferBankNameLabel.text = bankAccount.transferOutName
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy/MM/dd"
        let day = dateForMatter.string(from: bankAccount.date)
        cell.transferDate.text = day
        cell.transferNote.text = "備註:\(bankAccount.note)"
        cell.transferBankMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: bankAccount.transferOutMoney)) ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        detailBankAccountsTableView.deleteRows(at: [indexPath], with: .automatic)
        withdrawalBanks.remove(at: indexPath.row)
        WithdrawalBanks.saveBank(withdrawalBanks)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditTransferDetailsViewController,
           let row = withdrawDetailsTableView.indexPathForSelectedRow?.row
        {
            controller.bankAccount = specificMonthBankAccounts[row]
            controller.delegate = self
        }
    }
    
}

extension WithdrawalBanksDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            self.yearAndMonthBlockingView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
    }
    
    func closeYearAndMonthPickerView() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.yearAndMonthBlockingView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

extension WithdrawalBanksDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            specificMonthWithdrawalBanks = withdrawalBanks.filter ({ bankAccounts in
                bankAccounts.note.localizedStandardContains(searchText)
            })
        }else{
            specificMonthWithdrawalBanks = withdrawalBanks
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        withdrawDetailsSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}

extension WithdrawalBanksDetailViewController: EditTransferDetailsViewControllerDelegate {
    func editTransferDetails(_ bankAcoount: WithdrawalBanks, _ account: Accounts, handlingFee: Double) {
        if let row = withdrawDetailsTableView.indexPathForSelectedRow?.row {
            let bankAccountIndex = findIndexInWithdrawalBanks(specificMonthWithdrawalBanks[row])
            
            if let accountIndex = findIndexInAccounts(specificMonthWithdrawalBanks[row]) {
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
            
            withdrawalBanks[bankAccountIndex] = bankAcoount
            updateWithdrawalBanksSequence()
        }
        
    }
    
    func deleteTransferDetails(_ bankAccount: WithdrawalBanks) {
        withdrawalBanks.remove(at: findIndexInWithdrawalBanks(bankAccount))
        if let index = findIndexInAccounts(bankAccount) {
            accounts.remove(at: index)
        }
    }
    
    
}
