//
//  FrequentlyUsedIncomeTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/22.
//

import UIKit

class FrequentlyUsedIncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var incomePhoto: UIImageView!
    @IBOutlet weak var incomeTitleLabel: UILabel!
    @IBOutlet weak var incomeCategoryLabel: UILabel!
    @IBOutlet weak var incomeMoney: UILabel!
    @IBOutlet weak var incomeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
