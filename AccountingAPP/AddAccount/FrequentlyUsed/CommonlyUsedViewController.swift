//
//  CommonlyUsedViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/18.
//

import UIKit

class CommonlyUsedViewController: UIViewController {
    
    
    
    @IBOutlet var commonTableView: UITableView!
    
    static let commonIncome = Notification.Name("commonIncome")
    static let commonExpenditure = Notification.Name("commonExpediture")

    var commonAccounts = [CommonlyUsedAccount]() {
        didSet {
            CommonlyUsedAccount.saveCommonAccounts(commonAccounts)
            commonTableView.reloadData()
        }
    }
    
    var commonIncome = [CommonlyUsedIncome]() {
        didSet {
            CommonlyUsedIncome.saveCommonAccounts(commonIncome)
        }
    }
    
    var commonExpenditure = [CommonlyUsedExpenditure]() {
        didSet {
            CommonlyUsedExpenditure.saveCommonAccounts(commonExpenditure)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let commonIncome = CommonlyUsedIncome.loadCommonAccounts(),
           let commonExpenditure = CommonlyUsedExpenditure.loadCommonAccounts()
        {
            self.commonIncome = commonIncome
            self.commonExpenditure = commonExpenditure
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addCommonIncome), name: AddIncomeViewController.addCommonNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCommonExpenditure), name: AddExpenditureViewController.addCommonNotification, object: nil)
        //        CommonAccounts = CommonlyUsedViewController.accounts
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(commonAccounts)")
        //        print("\(CommonlyUsedViewController.accounts)")
    }
    
    @objc func addCommonIncome(_ noti: Notification) {
        if let user = noti.userInfo,
           let incomeAccount = user[ExpenditureOrIncome.income.rawValue] as? CommonlyUsedIncome {
            commonIncome.insert(incomeAccount, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            commonTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func addCommonExpenditure(_ noti: Notification) {
        if let user = noti.userInfo,
           let expenditureAccount = user[ExpenditureOrIncome.expenditure.rawValue] as? CommonlyUsedExpenditure {
            commonExpenditure.insert(expenditureAccount, at: 0)
            let indexPath = IndexPath(row: 0, section: 1)
            commonTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func editCommonAccounts(_ sender: UIButton) {
        commonTableView.setEditing(!commonTableView.isEditing, animated: true)
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

extension CommonlyUsedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
//            let accountCount = commonAccounts.reduce(into: [:]) { counts, account in
//                counts[account.expenditrueOrIncome, default: 0] += 1
//            }
//            return accountCount[ExpenditureOrIncome.income.rawValue] ?? 0
            return commonIncome.count
        case 1:
//            let accountCount = commonAccounts.reduce(into: [:]) { counts, account in
//                counts[account.expenditrueOrIncome, default: 0] += 1
//            }
//            return accountCount[ExpenditureOrIncome.expenditure.rawValue] ?? 0
            return commonExpenditure.count
        default:
            break
        }
        return 0
    }
    
//    func commonExpenditureOrIncome(_ accounts: [CommonlyUsedAccount], _ expenditureOrIncome: ExpenditureOrIncome) -> [CommonlyUsedAccount] {
//        let newArray = accounts.filter { account in
//            if account.expenditrueOrIncome == expenditureOrIncome.rawValue {
//                return true
//            }else{
//                return false
//            }
//        }
//        return newArray
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = commonTableView.dequeueReusableCell(withIdentifier: "\(CommonIncomeTableViewCell.self)", for: indexPath) as? CommonIncomeTableViewCell else { return UITableViewCell() }
//            let commonIncome = commonExpenditureOrIncome(self.commonAccounts, .income)
            let account = commonIncome[indexPath.row]
            cell.commonPhoto.image = UIImage(named: "\(account.category)")
            cell.commonTitleLabel.text = account.tittle
            cell.commonCategoryLabel.text = "\(account.category),\(account.subtype)"
            cell.commonMoney.text = account.money
            
            cell.commonButton.tag = indexPath.row
            cell.commonButton.addTarget(self, action: #selector(moveToIncomeViewController), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = commonTableView.dequeueReusableCell(withIdentifier: "\(CommonExpeditureTableViewCell.self)", for: indexPath) as? CommonExpeditureTableViewCell else { return UITableViewCell() }
//            let commonExpenditure = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
            let account = commonExpenditure[indexPath.row]
            cell.commonPhoto.image = UIImage(named: "\(account.category)")
            cell.commonTitleLabel.text = account.tittle
            cell.commonCategoryLabel.text = "\(account.category),\(account.subtype)"
            cell.commonMoney.text = account.money
            
            cell.commonButton.tag = indexPath.row
            cell.commonButton.addTarget(self, action: #selector(moveToExpenditureViewController), for: .touchUpInside)
            
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    @objc func moveToIncomeViewController(_ sender: UIButton) {
//        let commonIncome = commonExpenditureOrIncome(self.commonAccounts, .income)
        let account = commonIncome[sender.tag]
        NotificationCenter.default.post(name: CommonlyUsedViewController.commonIncome, object: nil, userInfo: [ExpenditureOrIncome.income.rawValue: account])
    }
    
    @objc func moveToExpenditureViewController(_ sender: UIButton) {
//        let commonExpenditure = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
        let account = commonExpenditure[sender.tag]
        NotificationCenter.default.post(name: CommonlyUsedViewController.commonExpenditure, object: nil, userInfo: [ExpenditureOrIncome.expenditure.rawValue: account])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
//                let incomeAccounts = commonExpenditureOrIncome(self.commonAccounts, .income)
//                let row = findIndexInCommonAccounts(incomeAccounts[indexPath.row])
                commonIncome.remove(at: indexPath.row)
                commonTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case 1:
            if editingStyle == .delete {
//                let expenditureAccounts = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
//                let row = findIndexInCommonAccounts(expenditureAccounts[indexPath.row])
                commonExpenditure.remove(at: indexPath.row)
                commonTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
//    func findIndexInCommonAccounts(_ deleteAccountsInDate: CommonlyUsedAccount) -> Int {
//        for (index, account) in self.commonAccounts.enumerated() {
//            if account.project == deleteAccountsInDate.project {
//                return index
//            }
//        }
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "收入"
        case 1:
            return "支出"
        default:
            break
        }
        return ""
    }
    
}


