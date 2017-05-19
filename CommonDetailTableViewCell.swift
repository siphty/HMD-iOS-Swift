//
//  CommonDetailTableViewCell.swift
//  HMD
//
//  Created by Yi JIANG on 16/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class CommonDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
