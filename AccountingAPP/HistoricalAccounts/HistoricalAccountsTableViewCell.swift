//
//  HistoricalAccountsTableViewCell.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/26.
//

import UIKit

class HistoricalAccountsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historicalSubTyoeLabel: UILabel!
    @IBOutlet weak var historicalDateLabel: UILabel!
    @IBOutlet weak var historicalMoneyLabel: UILabel!
    @IBOutlet weak var historicalNoteLabel: UILabel!
    @IBOutlet weak var historicalPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
