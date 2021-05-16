//
//  ViewController.swift
//  GithubStargazers
//
//  Created by Luigi Borchia on 13/05/21.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var repoTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var owner: String?
    var repo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search button is enabled only if an owner and a repo are inserted
        ownerTextField.addTarget(self, action: #selector(parametersInserted), for: .editingChanged)
        repoTextField.addTarget(self, action: #selector(parametersInserted), for: .editingChanged)

        self.hideKeyboard()
    }

    
    @IBAction func searchButtonPressed(_ sender: Any) {
        print("starting search")
        stargazers = []
        page = 1    //the first API call is always for the first page

        // API call handelr
        getStargazers(closure: {success, result in
            
            // Display an error message if any error occurs
            if success == false {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: "A problem occurred. Please retry later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
                
            } else {
                print("\(stargazers.count) stargazers retrieved")
                
                DispatchQueue.main.async {
                    if(stargazers.count > 0) {
                        self.performSegue(withIdentifier: "showList", sender: self)     // Go to the stargazers list only if there's any
                    } else {
                        let alert = UIAlertController(title: "", message: "No stargazers found for:\n\nowner: \(self.ownerTextField.text!)\nrepo: \(self.repoTextField.text!)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                }
                
            }
        })
    }
    
    
    // It's possible to choose the number of stargazers to retrieve for each API call.
    // The API allows the retrieval of max 100 user per request
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Stargazers pagination rate", message: "Select the number of stargazers to load for each API call.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "25", style: .default, handler: {_ in
            resultsPerPage = 25
        }))
        alert.addAction(UIAlertAction(title: "50", style: .default, handler: {_ in
            resultsPerPage = 50
        }))
        alert.addAction(UIAlertAction(title: "75", style: .default, handler: {_ in
            resultsPerPage = 75
        }))
        alert.addAction(UIAlertAction(title: "100", style: .default, handler: {_ in
            resultsPerPage = 100
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    
    // Data retrieval
    func getStargazers(closure: @escaping (_ success: Bool, _ json: [String:Any]) -> ()) {
        
        let sv = UIViewController.displaySpinner(onView: self.view)     // Loading spinner
        let owner = ownerTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)    //the search parameters are trimmed to avoid blank spaces
        let repo = repoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Error message is shown if the url can't be created
        guard let url = URL(string: "\(restAddress)/repos/\(owner)/\(repo)/stargazers?per_page=\(resultsPerPage)&page=\(page)") else {
            print("error in url creation")
            UIViewController.removeSpinner(spinner: sv)
            let alert = UIAlertController(title: "Error", message: "Can't create url.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        // API call through a global instance of NetworkManager class
        NetworkManager.shared.fetchStargazers(url: url, completion: { result in
            if result == nil {
                closure(false, [:])
            } else {
                for x in result! {
                    
                    // The result list is built
                    let user = x["login"] as? String ?? "n/a"
                    let imgUrl = x["avatar_url"] as? String ?? "n/a"
                    
                    stargazers.append(GitHubUser(username: user, proPicUrl: imgUrl))
                }
                
                UIViewController.removeSpinner(spinner: sv)
                
                closure(true, [:])
            }
        })
    }
    
    
    @objc func parametersInserted(_ textField: UITextField) {
        searchButton.isEnabled = !ownerTextField.text!.isEmpty && !repoTextField.text!.isEmpty
        searchButton.alpha = searchButton.isEnabled ? 1 : 0.5
    }
    
    
    // Pass data to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showList" {
            if let nextVC = segue.destination as? ListViewController {
                nextVC.user = ownerTextField.text!
                nextVC.repo = repoTextField.text!
            }
        }
    }
}




