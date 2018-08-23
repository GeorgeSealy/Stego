//
//  Account+CoreDataClass.swift
//  
//
//  Created by George Sealy on 20/08/18.
//
//

import Foundation
import CoreData

//extension DateFormatter {
//    func date(fromSwapiString dateString: String) -> Date? {
//        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
//        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
//        self.timeZone = TimeZone(abbreviation: "UTC")
//        self.locale = Locale(identifier: "en_US_POSIX")
//        return self.date(from: dateString)
//    }
//}


@objc(Account)
public class Account: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case id
        case username
        case displayName = "display_name"
        case acct
        case locked
        case createdAt = "created_at"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case statusesCount = "statuses_count"
        case note
        case url
        case avatar
        case avatarStatic = "avatar_static"
        case header
        case headerStatic = "header_static"
        case bot
        case moved

    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = decoder.userInfo[databaseKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Account", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decode(String.self, forKey: .id)
        

//        Log("\(type(of: self)) - \(#function): TIMESTAMP \(String(describing: try? container.decodeIfPresent(String.self, forKey: .createdAt)))")
        
        if
            let createdAtTimestamp = try container.decodeIfPresent(String.self, forKey: .createdAt),
            let date = Api.dateFormatter.date(from: createdAtTimestamp) {
            createdAt = date as NSDate
        } else {
            createdAt = NSDate(timeIntervalSince1970: 0)
            Log("\(type(of: self)) - \(#function): BAD, BAD timestamp")
        }
        
        username = try container.decodeIfPresent(String.self, forKey: .username)
        acct = try container.decodeIfPresent(String.self, forKey: .acct)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        locked = try container.decodeIfPresent(Bool.self, forKey: .locked) ?? false
        bot = try container.decodeIfPresent(Bool.self, forKey: .bot) ?? false
        moved = try container.decodeIfPresent(Bool.self, forKey: .moved) ?? false
        note = try container.decodeIfPresent(String.self, forKey: .note)
        followersCount = try container.decodeIfPresent(Int64.self, forKey: .followersCount) ?? 0
        followingCount = try container.decodeIfPresent(Int64.self, forKey: .followingCount) ?? 0
        statusesCount = try container.decodeIfPresent(Int64.self, forKey: .statusesCount) ?? 0
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        avatar = try container.decodeIfPresent(URL.self, forKey: .avatar)
        avatarStatic = try container.decodeIfPresent(URL.self, forKey: .avatarStatic)
        header = try container.decodeIfPresent(URL.self, forKey: .header)
        headerStatic = try container.decodeIfPresent(URL.self, forKey: .headerStatic)


    }
}

