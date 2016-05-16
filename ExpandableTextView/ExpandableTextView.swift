//  Copyright © 2016 Saul. All rights reserved.
//

import UIKit

class ExpandableTextView: UIView {
    @IBOutlet weak var textView: ExpandableText!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var characterCounter: UILabel!
    
    var placeholderText: String?
    var characterLimit: Int?
    var maxLines: Int?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("ExpandableTextView", owner: self, options: nil)
        self.addSubview(self.contentView)
        textView.button = sendButton
        textView.characterCounter = characterCounter
        sendButton.enabled = false
        characterCounter.hidden = true
    }
    
    func configureForMessaging() {
        sendButton.setTitle("Send", forState: .Normal)
        placeholderText = "Send a message"
        textView.placeholder = placeholderText
        textView.textViewStyling()
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 3
    }
    
    func configureUIForComment() {
        layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        textView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        placeholderText = "Add a comment"
        textView.characterLimit = 150
        textView.maxLines = 3
        textView.placeholder = placeholderText
        textView.textViewStyling()
        textView.textColor = UIColor.lightGrayColor()
    }
    
    func configureUIForNote() {
        contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = self.frame.height/2
        layer.cornerRadius = self.frame.height/2
        placeholderText = "Drop a note"
        textView.characterLimit = 150
        textView.placeholder = placeholderText
        textView.textViewStyling()
    }
}
