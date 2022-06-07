//
//  WithdrawalDetailsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/15.
//

import UIKit

class WithdrawalDetailsViewController: UIViewController {
    
    @IBOutlet weak var selectLhsdatePickerView: UIPickerView!
    @IBOutlet weak var selectRhsdatePickerView: UIPickerView!
    @IBOutlet weak var selectLhsdateButton: UIButton!
    @IBOutlet weak var selectRhsdateButton: UIButton!
    @IBOutlet weak var selectPickerViewBlockingView: UIView!
    @IBOutlet weak var withdrawDetailsTableView: UITableView!
    @IBOutlet weak var withdrawDetailsSearchBar: UISearchBar!
    @IBOutlet weak var withdrawalTotalMoneyLabel: UILabel!
    
    var accounts = [Accounts]() {
        didSet {
            Accounts.saveAccount(accounts)
        }
    }
    
    var withdrawalBanks = [WithdrawalBanks]() {
        didSet {
            print("test\(withdrawalBanks)")
            WithdrawalBanks.saveBank(withdrawalBanks)
            findSearchTextInSpecificDateInWithdrawalBanks(withdrawDetailsSearchBar.text ?? "")
        }
    }
    
    var specificDateWithdrawalBanks = [WithdrawalBanks]()
    {
        didSet {
            print("\(specificDateWithdrawalBanks)")
            if specificDateWithdrawalBanks.count == 0 {
                withdrawDetailsTableView.alpha = 0
                withdrawalTotalMoneyLabel.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificDateInWithdrawalBanksTatalMoney())) ?? "")"
                withdrawDetailsTableView.reloadData()
            }else{
                withdrawDetailsTableView.alpha = 1
                withdrawalTotalMoneyLabel.text = "總金額：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateSpecificDateInWithdrawalBanksTatalMoney())) ?? "")"
                withdrawDetailsTableView.reloadData()
            }
        }
    }
    
    var years: [String] = []
    var months: [String] = ["01月", "02月", "03月", "04月", "05月", "06月", "07月", "08月", "09月", "10月", "11月", "12月"]
    var days:[String] = []
    
    var currentLhsyearString: String = ""
    var currentLhsmonthString: String = ""
    var currentLhsdayString: String = ""
    var currentLhsdateString: String = "" {
        didSet {
            selectLhsdateButton.setTitle(currentLhsdateString, for: .normal)
            WithdrawalBanks.saveBank(withdrawalBanks)
            findSearchTextInSpecificDateInWithdrawalBanks(withdrawDetailsSearchBar.text ?? "")
        }
    }
    
    var currentRhsyearString: String = ""
    var currentRhsmonthString: String = ""
    var currentRhsdayString: String = ""
    var currentRhsdateString: String = "" {
        didSet{
            selectRhsdateButton.setTitle(currentRhsdateString, for: .normal)
            findSearchTextInSpecificDateInWithdrawalBanks(withdrawDetailsSearchBar.text ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectPickerViewBlockingView.alpha = 0
        if let bankAccounts = WithdrawalBanks.loadBank() {
            self.withdrawalBanks = bankAccounts
        }
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
        }
        
        withdrawDetailsSearchBar.addKeyboardReturn()
        updateWithdrawalBanksSequence()
        fetchYears()
        fetchDays()
    }
    
    func fetchYears() {
        let yearMonth = self.withdrawalBanks.reduce(into: [String:Int]()) { (counts, accounts) in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let date = dateForMatter.string(from: accounts.date)
            counts[date, default: 1] += 0
        }
        years = yearMonth.keys.sorted(by: >)
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
    
    func fetchSpecificDateInWithdrawalBanks(_ accounts: [WithdrawalBanks], _ lhsdateString: String, _ rhsdateString: String) -> [WithdrawalBanks] {
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
    
    func updateWithdrawalBanksSequence() {
        self.withdrawalBanks = withdrawalBanks.sorted(by: { lhs, rhs in
            let lhsTime = lhs.date
            let rhsTime = rhs.date
            return lhsTime > rhsTime
        })
    }
    
    func findIndexInAccounts(_ indexInWithdrawalBanks: WithdrawalBanks) -> Int? {
        for (index, account) in self.accounts.enumerated() {
            if account.accountsIndex == indexInWithdrawalBanks.withdrawalBanksIndex {
                return index
            }
        }
        return nil
    }
    
    func findIndexInWithdrawalBanks(_ indexInWithdrawalBanks: WithdrawalBanks) -> Int {
        for (index, bankAccount) in self.withdrawalBanks.enumerated() {
            if bankAccount.withdrawalBanksIndex == indexInWithdrawalBanks.withdrawalBanksIndex {
                return index
            }
        }
        return 0
    }
    
    func calculateSpecificDateInWithdrawalBanksTatalMoney() -> Double {
        let total = specificDateWithdrawalBanks.reduce(0.0) { partialResult, withdrawalBanks in
            return partialResult + withdrawalBanks.transferOutMoney
        }

        return total
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

extension WithdrawalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificDateWithdrawalBanks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = withdrawDetailsTableView.dequeueReusableCell(withIdentifier: "\(BankDetailTableViewCell.self)", for: indexPath) as? BankDetailTableViewCell else
        { return UITableViewCell() }
        
        let bankAccount = specificDateWithdrawalBanks[indexPath.row]
        cell.bankDetailNameLabel.text = bankAccount.transferOutName
        
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy/MM/dd"
        let day = dateForMatter.string(from: bankAccount.date)
        cell.bankDetailDate.text = day
        cell.bankDetailNote.text = "備註:\(bankAccount.note)"
        cell.bankDetailMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: bankAccount.transferOutMoney)) ?? ""
        cell.bankDetailPhoto.image = UIImage(named: bankAccount.transferOutName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditWithdrawalDetailsViewController,
           let row = withdrawDetailsTableView.indexPathForSelectedRow?.row
        {
            controller.withdrawalBank = specificDateWithdrawalBanks[row]
            controller.delegate = self
        }
    }
    
}

extension WithdrawalDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
           let dayIndex = days.firstIndex(of: currentLhsdayString)
        {
            self.selectLhsdatePickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            self.selectLhsdatePickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            self.selectLhsdatePickerView.selectRow(dayIndex, inComponent: 2, animated: false)
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

extension WithdrawalDetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
findSearchTextInSpecificDateInWithdrawalBanks(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findSearchTextInSpecificDateInWithdrawalBanks(searchBar.text ?? "")
        withdrawDetailsSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func findSearchTextInSpecificDateInWithdrawalBanks(_ searchText: String) {
        if searchText.isEmpty == false {
            specificDateWithdrawalBanks = fetchSpecificDateInWithdrawalBanks(withdrawalBanks, currentLhsdateString, currentRhsdateString).filter ({ WithdrawalBanks in
                WithdrawalBanks.transferOutName.localizedStandardContains(searchText) ||
                WithdrawalBanks.note.localizedStandardContains(searchText)
            })
        }else{
            specificDateWithdrawalBanks = fetchSpecificDateInWithdrawalBanks(withdrawalBanks, currentLhsdateString, currentRhsdateString)
        }
    }
    
}

extension WithdrawalDetailsViewController: EditWithdrawalDetailsViewControllerDelegate {
    
    func editWithdrawalDetails(_ withdrawalBank: WithdrawalBanks, _ account: Accounts, handlingFee: Double) {
        if let row = withdrawDetailsTableView.indexPathForSelectedRow?.row {
            let withdrawalBanksIndex = findIndexInWithdrawalBanks(specificDateWithdrawalBanks[row])
            
            if let accountIndex = findIndexInAccounts(specificDateWithdrawalBanks[row]) {
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
            
            withdrawalBanks[withdrawalBanksIndex] = withdrawalBank
            updateWithdrawalBanksSequence()
        }
    }
    
    func deleteWithdrawalDetails(_ withdrawalBank: WithdrawalBanks) {
        withdrawalBanks.remove(at: findIndexInWithdrawalBanks(withdrawalBank))
        if let index = findIndexInAccounts(withdrawalBank) {
            accounts.remove(at: index)
        }
    }
    
}

