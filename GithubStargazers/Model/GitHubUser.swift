//
//  GitHubUser.swift
//  GithubStargazers
//
//  Created by Luigi Borchia on 14/05/21.
//

import Foundation
import UIKit

class GitHubUser {
    var username: String
    var proPicUrl: String
    var proPic: UIImage?
    
    init(username: String, proPicUrl: String) {
        self.username = username
        self.proPicUrl = proPicUrl
        getProPic()
    }
    
    func getProPic() {
        guard let url = URL(string: proPicUrl) else { return }
            
        guard let data = try? Data(contentsOf: url) else { return }

        let image = UIImage(data: data)
        self.proPic = image
    }
    
}
