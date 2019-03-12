//
//  OpponentBalloonTableViewCell.swift
//  emessenger
//
//  Created by hideaki_tanabe on 2018/06/24.
//  Copyright © 2018年 Hideaki Tanabe. All rights reserved.
//

import UIKit

class OppoenentBalloonTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        accessoryType = .none
        selectionStyle = .none
    }
    
    func configure(userName: String, message: String, date: String) {
        userNameLabel.text = userName
        messageLabel.text = message
        dateLabel.text = date
    }
}
