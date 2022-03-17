//
//  FrequentlyViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import UIKit

class FrequentlyViewController: UIViewController {

    @IBOutlet var commonTableView: UITableView!
    
    static let frequentlyIncome = Notification.Name("frequentlyIncome")
    static let frequentlyExpediture = Notification.Name("frequentlyExpediture")

    var commonAccounts = [CommonlyUsedAccount]() {
        didSet {
            CommonlyUsedAccount.saveCommonAccounts(commonAccounts)
            commonTableView.reloadData()
        }
    }
    
    var frequentlyUsedIncome = [FrequentlyUsedIncome]() {
        didSet {
            FrequentlyUsedIncome.saveFrequentlyUsedIncome(frequentlyUsedIncome)
        }
    }
    
    var frequentlyUsedExpenditure = [FrequentlyUsedExpenditure]() {
        didSet {
            FrequentlyUsedExpenditure.saveFrequentlyUsedExpenditure(frequentlyUsedExpenditure)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let frequentlyUsedIncome = FrequentlyUsedIncome.loadFrequentlyUsedIncome(),
           let frequentlyUsedExpenditure = FrequentlyUsedExpenditure.loadFrequentlyUsedExpenditure()
        {
            self.frequentlyUsedIncome = frequentlyUsedIncome
            self.frequentlyUsedExpenditure = frequentlyUsedExpenditure
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addFrequentlyUsedIncome), name: AddIncomeViewController.addCommonNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFrequentlyUsedExpenditure), name: AddExpenditureViewController.addCommonNotification, object: nil)
        //        CommonAccounts = CommonlyUsedViewController.accounts
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(commonAccounts)")
        //        print("\(CommonlyUsedViewController.accounts)")
    }
    
    @objc func addFrequentlyUsedIncome(_ noti: Notification) {
        if let user = noti.userInfo,
           let frequentlyUsedIncome = user[ExpenditureOrIncome.income.rawValue] as? FrequentlyUsedIncome {
            self.frequentlyUsedIncome.insert(frequentlyUsedIncome, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            commonTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func addFrequentlyUsedExpenditure(_ noti: Notification) {
        if let user = noti.userInfo,
           let frequentlyUsedExpenditure = user[ExpenditureOrIncome.expenditure.rawValue] as? FrequentlyUsedExpenditure {
            self.frequentlyUsedExpenditure.insert(frequentlyUsedExpenditure, at: 0)
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

extension FrequentlyViewController: UITableViewDataSource {
    
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
            return frequentlyUsedIncome.count
        case 1:
//            let accountCount = commonAccounts.reduce(into: [:]) { counts, account in
//                counts[account.expenditrueOrIncome, default: 0] += 1
//            }
//            return accountCount[ExpenditureOrIncome.expenditure.rawValue] ?? 0
            return frequentlyUsedExpenditure.count
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
            let income = frequentlyUsedIncome[indexPath.row]
            cell.commonPhoto.image = UIImage(named: "\(income.category)")
            cell.commonTitleLabel.text = income.tittle
            cell.commonCategoryLabel.text = "\(income.category),\(income.subtype)"
            cell.commonMoney.text = income.money
            
            cell.commonButton.tag = indexPath.row
            cell.commonButton.addTarget(self, action: #selector(moveToIncomeViewController), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = commonTableView.dequeueReusableCell(withIdentifier: "\(CommonExpeditureTableViewCell.self)", for: indexPath) as? CommonExpeditureTableViewCell else { return UITableViewCell() }
//            let commonExpenditure = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
            let expenditure = frequentlyUsedExpenditure[indexPath.row]
            cell.commonPhoto.image = UIImage(named: "\(expenditure.category)")
            cell.commonTitleLabel.text = expenditure.tittle
            cell.commonCategoryLabel.text = "\(expenditure.category),\(expenditure.subtype)"
            cell.commonMoney.text = expenditure.money
            
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
        let account = frequentlyUsedIncome[sender.tag]
        NotificationCenter.default.post(name: FrequentlyViewController.frequentlyIncome, object: nil, userInfo: [ExpenditureOrIncome.income.rawValue: account])
    }
    
    @objc func moveToExpenditureViewController(_ sender: UIButton) {
//        let commonExpenditure = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
        let account = frequentlyUsedExpenditure[sender.tag]
        NotificationCenter.default.post(name: FrequentlyViewController.frequentlyExpediture, object: nil, userInfo: [ExpenditureOrIncome.expenditure.rawValue: account])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
//                let incomeAccounts = commonExpenditureOrIncome(self.commonAccounts, .income)
//                let row = findIndexInCommonAccounts(incomeAccounts[indexPath.row])
                frequentlyUsedIncome.remove(at: indexPath.row)
                commonTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case 1:
            if editingStyle == .delete {
//                let expenditureAccounts = commonExpenditureOrIncome(self.commonAccounts, .expenditure)
//                let row = findIndexInCommonAccounts(expenditureAccounts[indexPath.row])
                frequentlyUsedExpenditure.remove(at: indexPath.row)
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


