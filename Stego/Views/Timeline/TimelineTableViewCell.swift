//
//  TimelineTableViewCell.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit
import AlamofireImage

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
    @IBOutlet weak var attachmentStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func clearAttachments() {
        
        for view in attachmentStackView.arrangedSubviews {
            
            if let imageView = view as? UIImageView {
                imageView.af_cancelImageRequest()
            }
            view.removeFromSuperview()
        }
    }
    
    func addImage(url: URL, aspect: CGFloat) {
        
        let imageView = UIImageView()
        
        imageView.af_setImage(withURL: url)
        switch attachmentStackView.arrangedSubviews.count % 3 {
        case 0:
            imageView.backgroundColor = .red
            
        case 1:
            imageView.backgroundColor = .green
            
        default:
            imageView.backgroundColor = .blue
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        attachmentStackView.addArrangedSubview(imageView)
        
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1.0 / aspect, constant: 0)
        heightConstraint.isActive = true
    }
    
    override func prepareForReuse() {
        clearAttachments()
    }
}
