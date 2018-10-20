//
//  UsersTableViewCell.swift
//  SampleBasicApp
//
//  Created by Xona on 10/7/18.
//  Copyright © 2018 Xona. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var firstNameLbl: UILabel!{
        didSet {
            firstNameLbl.numberOfLines = 0
        }
    }
    @IBOutlet weak var lastNameLbl: UILabel!{
        didSet {
            lastNameLbl.numberOfLines = 0
        }
    }
    @IBOutlet weak var ageLbl: UILabel!{
        didSet {
            ageLbl.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
