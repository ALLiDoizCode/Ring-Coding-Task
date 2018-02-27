//
//  Client.swift
//  Coding-Task
//
//  Created by Jonathan on 2/26/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation

class Client {
    
    func fetch(after:String,completion:@escaping (_ json:Data) -> Void) {
        
        let redditURL = URL(string:"https://www.reddit.com/top.json?limit=50&after=\(after)")
        
        guard let requestURL = redditURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) {(data, response, error) in
            
            guard error == nil else {
                print("error:\(error.debugDescription)")
                return
            }
            
            guard let json = data else {
                return
            }
            
            completion(json)
        
        }
        
        task.resume()
    }
}
