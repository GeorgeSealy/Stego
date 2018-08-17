//
//  StatusModel.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

//struct StatusModel: Decodable {
//    
//    let id: String
//    let createdAt: Date
//    let url: URL
//    let account: AccountModel?
//    let content: String
//
//    enum CodingKey: String, Swift.CodingKey {
//        case id
//        case createdAt = "created_at"
//        case url
//        case account
//        case content
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKey.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        
//        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
//        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
//        
//        url = try container.decode(URL.self, forKey: .content)
//        account = try? container.decode(AccountModel.self, forKey: .account)
//        content = try container.decode(String.self, forKey: .content)
//    }
//}

//    uri     A Fediverse-unique resource ID     no
//    url     URL to the status page (can be remote)     yes
//    account     The Account which posted the status     no
//    in_reply_to_id     null or the ID of the status it replies to     yes
//    in_reply_to_account_id     null or the ID of the account it replies to     yes
//    reblog     null or the reblogged Status     yes
//    content     Body of the status; this will contain HTML (remote HTML already sanitized)     no
//    created_at     The time the status was created     no
//    emojis     An array of Emoji     no
//    reblogs_count     The number of reblogs for the status     no
//    favourites_count     The number of favourites for the status     no
//    reblogged     Whether the authenticated user has reblogged the status     yes
//    favourited     Whether the authenticated user has favourited the status     yes
//    muted     Whether the authenticated user has muted the conversation this status from     yes
//    sensitive     Whether media attachments should be hidden by default     no
//    spoiler_text     If not empty, warning text that should be displayed before the actual content     no
//    visibility     One of: public, unlisted, private, direct     no
//    media_attachments     An array of Attachments     no
//    mentions     An array of Mentions     no
//    tags     An array of Tags     no
//    application     Application from which the status was posted     yes
//    language     The detected language for the status, if detected     yes
//    pinned     Whether this is the pinned status for the account that posted it     yes
