//  Copyright © 2016 Saul. All rights reserved.
//

import UIKit

class ExpandableText: UITextView, UITextViewDelegate {
    var characterCounter: UILabel!
    var heightConstraint: NSLayoutConstraint?
    var button: UIButton!
    var placeholder: String!
    
    var maxLines: Int?
    var characterLimit: Int?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
    }

    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRectWithSize(CGSize(width: width, height: DBL_MAX), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font],  context: nil).size
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.window != nil {
            if text == placeholder {
                dispatch_async(dispatch_get_main_queue(), {
                    self.selectedTextRange = self.textRangeFromPosition(self.beginningOfDocument, toPosition: self.beginningOfDocument)
                })
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
            characterCounter.hidden = true
            button.enabled = false
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset))
        let boundingRect = sizeOfString(textView.text, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight
        guard let max = self.maxLines else {
            return
        }
        if numberOfLines >= CGFloat(max) {
            createHeightConstraint()
            textView.scrollEnabled = true
            let bottom = contentSize.height - (frame.height)
            setContentOffset(CGPoint(x: 0, y: bottom), animated: false)
        } else {
            removeHeightConstraint()
            textView.scrollEnabled = false
            textView.sizeThatFits(CGSize(width: fixedWidth, height: boundingRect.height))
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        if updatedText.isEmpty {
            button.enabled = false
            characterCounter.hidden = true
            removeHeightConstraint()
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            return false
        }
        else if textView.text == placeholder && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            if !text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
                button.enabled = true
            }
        }
        guard let characterLimit = self.characterLimit else {
            return true
        }
        
        if text.characters.count > characterLimit {
            let index = text.startIndex.advancedBy(characterLimit)
            textView.text = text.substringToIndex(index)
            removeHeightConstraint()
        }
        updateCharacters(characterLimit - textView.text.characters.count)
        return textView.text.characters.count + (text.characters.count - range.length) <= characterLimit
    }

    
    func removeHeightConstraint() {
        guard let constraint = heightConstraint else {
            return
        }
        removeConstraint(constraint)
        heightConstraint = nil
    }
    
    func createHeightConstraint() {
        let textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(frame, textContainerInset))
        let boundingRect = sizeOfString(text, constrainedToWidth: Double(textWidth), font: font!)
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: boundingRect.height+20)
            addConstraint(heightConstraint!)
        }
    }
    
    func textViewStyling() {
        textColor = UIColor.lightGrayColor()
        scrollEnabled = false
        text = placeholder
        selectedTextRange = textRangeFromPosition(beginningOfDocument, toPosition: beginningOfDocument)
    }
    
    func updateCharacters(count: Int) {
        characterCounter.text = String(count)
        switch count {
        case 0...10:
            characterCounter.hidden = false
            characterCounter.textColor = UIColor.redColor()
        case 10...50:
            characterCounter.hidden = false
            characterCounter.textColor = UIColor.blackColor()
        default:
            characterCounter.hidden = true
            break
        }
    }

}
