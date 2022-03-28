//
//  FrequentlyUsedViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import UIKit

class FrequentlyUsedViewController: UIViewController {

    @IBOutlet weak var frequentlyUsedTableView: UITableView!
    
    static let frequentlyIncomeNotification = Notification.Name("frequentlyIncome")
    static let frequentlyExpeditureNotification = Notification.Name("frequentlyExpediture")

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(addFrequentlyUsedIncome), name: AddIncomeViewController.addFrequentlyUsedIncomeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFrequentlyUsedExpenditure), name: AddExpenditureViewController.addFrequentlyUsedExpenditureNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func addFrequentlyUsedIncome(_ noti: Notification) {
        if let user = noti.userInfo,
           let frequentlyUsedIncome = user[ExpenditureOrIncome.income.rawValue] as? FrequentlyUsedIncome {
            self.frequentlyUsedIncome.insert(frequentlyUsedIncome, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            frequentlyUsedTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func addFrequentlyUsedExpenditure(_ noti: Notification) {
        if let user = noti.userInfo,
           let frequentlyUsedExpenditure = user[ExpenditureOrIncome.expenditure.rawValue] as? FrequentlyUsedExpenditure {
            self.frequentlyUsedExpenditure.insert(frequentlyUsedExpenditure, at: 0)
            let indexPath = IndexPath(row: 0, section: 1)
            frequentlyUsedTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func editCommonAccounts(_ sender: UIButton) {
        frequentlyUsedTableView.setEditing(!frequentlyUsedTableView.isEditing, animated: true)
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

extension FrequentlyUsedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return frequentlyUsedIncome.count
        case 1:
            return frequentlyUsedExpenditure.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = frequentlyUsedTableView.dequeueReusableCell(withIdentifier: "\(FrequentlyUsedIncomeTableViewCell.self)", for: indexPath) as? FrequentlyUsedIncomeTableViewCell else { return UITableViewCell() }
            let income = frequentlyUsedIncome[indexPath.row]
            cell.incomePhoto.image = UIImage(named: "\(income.category)")
            cell.incomeTitleLabel.text = income.tittle
            cell.incomeCategoryLabel.text = "\(income.category),\(income.subtype)"
            cell.incomeMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: income.money))
            cell.incomeMoney.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
            
            cell.incomeButton.tag = indexPath.row
            cell.incomeButton.addTarget(self, action: #selector(moveToIncomeViewController), for: .touchUpInside)
            
            return cell
        case 1:
            guard let cell = frequentlyUsedTableView.dequeueReusableCell(withIdentifier: "\(FrequentlyUsedIExpenditureTableViewCell.self)", for: indexPath) as? FrequentlyUsedIExpenditureTableViewCell else { return UITableViewCell() }
            let expenditure = frequentlyUsedExpenditure[indexPath.row]
            cell.expenditurePhoto.image = UIImage(named: "\(expenditure.category)")
            cell.expenditureTitleLabel.text = expenditure.tittle
            cell.expenditureCategoryLabel.text = "\(expenditure.category),\(expenditure.subtype)"
            cell.expenditureMoney.text = NumberStyle.currencyStyle().string(from: NSNumber(value: expenditure.money))
            cell.expenditureMoney.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
            
            cell.expenditureButton.tag = indexPath.row
            cell.expenditureButton.addTarget(self, action: #selector(moveToExpenditureViewController), for: .touchUpInside)
            
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    @objc func moveToIncomeViewController(_ sender: UIButton) {
        let account = frequentlyUsedIncome[sender.tag]
        NotificationCenter.default.post(name: FrequentlyUsedViewController.frequentlyIncomeNotification, object: nil, userInfo: [ExpenditureOrIncome.income.rawValue: account])
    }
    
    @objc func moveToExpenditureViewController(_ sender: UIButton) {
        let account = frequentlyUsedExpenditure[sender.tag]
        NotificationCenter.default.post(name: FrequentlyUsedViewController.frequentlyExpeditureNotification, object: nil, userInfo: [ExpenditureOrIncome.expenditure.rawValue: account])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if editingStyle == .delete {
                frequentlyUsedIncome.remove(at: indexPath.row)
                frequentlyUsedTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case 1:
            if editingStyle == .delete {
                frequentlyUsedExpenditure.remove(at: indexPath.row)
                frequentlyUsedTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
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


