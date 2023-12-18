//
//  UserCell.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 13/11/23.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var userId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
