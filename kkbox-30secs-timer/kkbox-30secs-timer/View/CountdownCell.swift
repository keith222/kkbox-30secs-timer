//
//  CountdownCell.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/5.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit

class CountdownCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
