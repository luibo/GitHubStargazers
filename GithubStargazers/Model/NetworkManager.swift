//
//  NetworkManager.swift
//  GithubStargazers
//
//  Created by Luigi Borchia on 14/05/21.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    var isPaginating = false
    
    func fetchStargazers(url: URL, completion: @escaping ([[String:Any]]?)->() ) {

        isPaginating = true
        print("Url: \(url)")
            
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            // check for any error
            guard error == nil else {
                print("error calling GET on")
                let nsError = error as NSError?
                print(nsError?.localizedDescription ?? "session error" )
                completion(nil)
                return
            }
            
            // check data
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(nil)
                return
            }
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                    print("error in json serialization")
                    
                    completion([])
                    return
                }
                
                completion(jsonData)
                self.isPaginating = false
                
            } catch let error as NSError {
              print(error)
                completion(nil)
                return
            }
        }
        task.resume()
    }
    
}

