//
//  UserCellTableViewCell.swift
//  justChat
//
//  Created by Наталья Атюкова on 20.03.2023.
//

import UIKit

class UserCellTableViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    static let reuseId = "UserCellTableViewCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(_ name: String){
        userName.text = name
    }
    
    func settingCell() {
        parentView.layer.cornerRadius = 10
        userImage.layer.cornerRadius =  userImage.frame.width/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
