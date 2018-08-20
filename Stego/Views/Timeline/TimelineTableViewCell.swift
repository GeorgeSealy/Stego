//
//  TimelineTableViewCell.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    static private var internalDateFormatter: DateFormatter?
    
    static var dateFormatter: DateFormatter {
        
        if let result = internalDateFormatter {
            return result
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        internalDateFormatter = dateFormatter
        
        return dateFormatter
    }
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
