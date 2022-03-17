//
//  CategoryTableViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import UIKit

protocol CategoryTableViewControllerDelegate {
    func getCategoryString(_ categoryString: String)
}

class CategoryTableViewController: UITableViewController {

    var items: [String] = []
    
    var itemsName: allCategories = .none
    
    var delegate: CategoryTableViewControllerDelegate?
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SharedTableViewCell.self)", for: indexPath) as? SharedTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        cell.itemsLabel.text = item
        cell.itemsPhoto.image = UIImage(named: item)
        

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getCategoryString(items[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    
}
