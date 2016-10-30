//
//  User.swift responsible for capturing data type on my server
//  Twitter
//
//  Created by Estella Lai on 10/29/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // stored property
    var name : NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    // deserialization code
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenName = dictionary["screen_name"] as? String as NSString?
        tagline = dictionary["description"] as? String as NSString?
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
    }

    static var _currentUser: User?
    // computed property - not stored associated with the variable
    class var currentUser: User? {
        // NSUserDefault persisted key value store, cookies for iOS
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set (user) {
            _currentUser = user
            // save the user any time i use user.currentUser =
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
     }
    
    
}
