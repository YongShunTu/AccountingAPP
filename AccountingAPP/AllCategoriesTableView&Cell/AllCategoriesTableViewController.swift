//
//  AllCategoriesTableViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/16.
//

import UIKit

protocol AllCategoriesTableViewControllerDelegate {
    func getItemsString(_ allcategories: allCategories, _ itemsString: String)
}

class AllCategoriesTableViewController: UITableViewController {

    var items: [String] = []
    
    var itemsName: allCategories = .none
    
    var categoryItemsPhotoName: String = ""
    
    var delegate: AllCategoriesTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AllCategoriesTableViewCell.self)", for: indexPath) as? AllCategoriesTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]

        if itemsName.rawValue == allCategories.subType.rawValue {
            cell.itemsLabel.text = item
            cell.itemsPhoto.image = UIImage(named: categoryItemsPhotoName)
        }else{
            cell.itemsLabel.text = item
            cell.itemsPhoto.image = UIImage(named: item)
        }

        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.getItemsString(itemsName, items[indexPath.row])
            dismiss(animated: true, completion: nil)
    }
    
}
