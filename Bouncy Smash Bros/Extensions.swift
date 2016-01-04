//
//  Extensions.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 10/2/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import Foundation

extension Dictionary {
    
    // Loads a JSON file from the app bundle into a new dictionary
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            var error: NSError?
            let data: NSData?
            do {
                data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
            } catch let error1 as NSError {
                error = error1
                data = nil
            }
            if let data = data {
                
                let dictionary: AnyObject?
                do {
                    dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                } catch let error1 as NSError {
                    error = error1
                    dictionary = nil
                }
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return dictionary
                } else {
                    print("Level file '\(filename)' is not valid JSON: \(error!)")
                    return nil
                }
            } else {
                print("Could not load level file: \(filename), error: \(error!)")
                return nil
            }
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
}


