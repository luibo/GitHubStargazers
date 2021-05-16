//
//  StargazerCell.swift
//  GithubStargazers
//
//  Created by Luigi Borchia on 14/05/21.
//

import UIKit

class StargazerCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView! {
        didSet {
            profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
