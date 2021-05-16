//
//  ListViewController.swift
//  GithubStargazers
//
//  Created by Luigi Borchia on 14/05/21.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var gazersTableView: UITableView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    
    var user: String?
    var repo: String?
    var stopSearching = (stargazers.count < resultsPerPage) ? true: false   // This flag is used to avoid API calls after all the stargazers of a project are retrieved

    override func viewDidLoad() {
        super.viewDidLoad()

        ownerLabel.text = "Owner: \(user ?? "n/a")"
        repoLabel.text = "Repository: \(repo ?? "n/a")"
        
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func retrieveData() {

        DispatchQueue.global().async {
            page += 1   // Each new API call requests a new page of results

            if let url = URL(string: "\(restAddress)/repos/\(self.user!)/\(self.repo!)/stargazers?per_page=\(resultsPerPage)&page=\(page)") {
                
                NetworkManager.shared.fetchStargazers(url: url, completion: { result in
                    if result == nil {
                        return
                    } else {
                        
                        print("\(result?.count ?? 0) stargazers retrieved")

                        if result!.count < resultsPerPage {     // All stargazers have been retrieved
                            self.stopSearching = true
                        }
                        
                        for x in result! {
                            let user = x["login"] as? String ?? "n/a"
                            let imgUrl = x["avatar_url"] as? String ?? "n/a"
                            
                            stargazers.append(GitHubUser(username: user, proPicUrl: imgUrl))
                        }
                        
                        DispatchQueue.main.async {
                            
                            if self.stopSearching {
                                self.gazersTableView.tableFooterView = nil
                            }
                            
                            self.gazersTableView.reloadData()
                        }
                        
                    }
                })
            } else {
                print("error")
            }
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // The stargazers are shown as a list in a tableview.
    // The stargazers pagination is handled with the infinite scroll technique.
    // When the user scrolls down to the end of the tableview, a new API call is made. The new call requests
    // a new page of results, that follows the page retrieved with the previous call.
    // This only happens if the API call returns n = m stargazers, where n is the number of stargazers and
    // m is the maximum number of stargazers requested per page.

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stargazers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! StargazerCell
        
        cell.username.text = stargazers[indexPath.row].username
        cell.profilePicture.image = stargazers[indexPath.row].proPic
        
        return cell
    }
        
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if stopSearching {
            return      // All results retrieved, no need to make other requests
        }
        
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > gazersTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            // Here we make sure to not send other requests if another request is still in progress
            guard !NetworkManager.shared.isPaginating else {
                return
            }
            
            self.gazersTableView.tableFooterView = createSpinnerFooter()
            
            retrieveData()
        }
    }
    
    
    // Loading spinner at the tableview bottom
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: gazersTableView.frame.size.width, height: 55))

        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
}
