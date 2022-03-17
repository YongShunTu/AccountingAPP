//
//  FrequentlyUsedIExpenditureTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import UIKit

class FrequentlyUsedIExpenditureTableViewCell: UITableViewCell {

    @IBOutlet weak var expenditurePhoto: UIImageView!
    @IBOutlet weak var expenditureTitleLabel: UILabel!
    @IBOutlet weak var expenditureCategoryLabel: UILabel!
    @IBOutlet weak var expenditureMoney: UILabel!
    @IBOutlet weak var expenditureButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
