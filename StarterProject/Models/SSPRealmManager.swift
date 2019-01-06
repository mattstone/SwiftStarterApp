//
//  SSPRealmManager.swift
//  StarterProject
//
//  Created by Matt Stone on 6/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import RealmSwift

class SSPRealmManager {
    
    static let sharedInstance = SSPRealmManager()
    

    public static var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            } catch {
                print("Could not access database: ", error)
            }
            return self.realm
        }
    }

    public static func write(writeClosure: @escaping (_ realm: Realm) -> ()) {
        do {
            try self.realm.write {
                // self.realm has so can `!`
                writeClosure(self.realm)
            }
        } catch let error {
            print("realm write error: \(error)")
        }
    }

    
}
