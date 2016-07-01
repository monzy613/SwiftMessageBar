//
//  Created by Jan Gorman on 25/08/15.
//  Copyright (c) 2015 Schnaub. All rights reserved.
//

import UIKit

internal protocol Identifiable {
    
    func id() -> UUID
    
}

internal final class Message: UIView {
    
    private static let Padding: CGFloat = 10
    private static let MessageOffset: CGFloat = 2
    private static let IconSize: CGFloat = 36
    private static let ButtonWidth: CGFloat = 20.0
    private static let ButtonHeight: CGFloat = 10.0
    
    private let uuid = UUID()
    private var title: String?
    private var message: String?
    private var titleFontColor: UIColor!
    private var messageFontColor: UIColor!
    private var icon: UIImage?
    internal var isHit: Bool = false
    internal private(set) var callback: Callback?
    internal private(set) var duration: TimeInterval!
    internal private(set) var dismiss: Bool = true
    private var titleFont: UIFont!
    private var messageFont: UIFont!

    
    private var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .left
        return paragraphStyle
    }
    
    init(title: String?, message: String?, backgroundColor: UIColor, titleFontColor: UIColor, messageFontColor: UIColor,
        icon: UIImage?, duration: TimeInterval, dismiss: Bool = true, callback: Callback?) {
        super.init(frame: CGRect.zero)
        sharedInit(title: title, message: message, backgroundColor: backgroundColor, titleFontColor: titleFontColor, messageFontColor: messageFontColor, icon: icon, duration: duration, callback: callback)
        self.backgroundColor = backgroundColor
        usesAutoLayout(true)
        initSubviews()
    }
    
    init(title: String?, message: String?, copybuttonPrototype: UIButton?, dismissbuttonPrototype: UIButton?, backgroundColor: UIColor, titleFontColor: UIColor, messageFontColor: UIColor,
         icon: UIImage?, duration: TimeInterval, dismiss: Bool = true, callback: Callback?) {
        super.init(frame: CGRect.zero)
        sharedInit(title: title, message: message, backgroundColor: backgroundColor, titleFontColor: titleFontColor, messageFontColor: messageFontColor, icon: icon, duration: duration, callback: callback)
        self.backgroundColor = backgroundColor
        usesAutoLayout(true)
        if let copyButton = copybuttonPrototype, let dismissButton = dismissbuttonPrototype {
            initSubviews(withCopyButton: copyButton, dismissButton: dismissButton)
        } else {
            initSubviews()
        }
    }
    
    private func sharedInit(title: String?, message: String?, backgroundColor: UIColor, titleFontColor: UIColor, messageFontColor: UIColor,
                            icon: UIImage?, duration: TimeInterval, dismiss: Bool = true, callback: Callback?) {
        titleFont = .boldSystemFont(ofSize: 16)
        messageFont = .systemFont(ofSize: 14)
        self.title = title
        self.message = message
        self.duration = duration
        self.callback = callback
        self.titleFontColor = titleFontColor
        self.messageFontColor = messageFontColor
        self.icon = icon
        self.dismiss = dismiss
    }        
    
    private func initSubviews() {
        let iconImageView = initIcon()
        let titleLabel = initTitle()
        let messageLabel = initMessage()

        let views = ["icon": iconImageView, "title": titleLabel, "message": messageLabel]
        let metrics = [
            "iconTop": Message.Padding,
            "titleTop": Message.Padding,
            "right": Message.Padding,
            "bottom": Message.Padding,
            "messageLeft": Message.Padding + Message.MessageOffset,
            "iconLeft": Message.Padding,
            
            "padding": Message.MessageOffset,
            "width": Message.IconSize,
            "height": Message.IconSize
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[icon(==width)]", options: [],
                                                      metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[icon(==height)]", options: [],
                                                      metrics: metrics, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-iconLeft-[icon]-messageLeft-[title]-right-|",
                                                      options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-iconLeft-[icon]-messageLeft-[message]-right-|",
                                                      options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-titleTop-[title]-padding-[message]-bottom-|",
                                                      options: [], metrics: metrics, views: views))
        
        if let message = message where !message.isEmpty {
            addConstraint(NSLayoutConstraint(item: iconImageView,
                                             attribute: NSLayoutAttribute.centerY,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: messageLabel,
                                             attribute: NSLayoutAttribute.centerY,
                                             multiplier: (title?.isEmpty ?? true) ? 1 : 0.8,
                                             constant: 0))
        } else if let title = title where !title.isEmpty {
            addConstraint(NSLayoutConstraint(item: iconImageView,
                                             attribute: NSLayoutAttribute.centerY,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: titleLabel,
                                             attribute: NSLayoutAttribute.centerY,
                                             multiplier: 1.0,
                                             constant: 0))
        }
    }
    
    private func initSubviews(withCopyButton copyButton: UIButton, dismissButton: UIButton) {        
        let iconImageView = initIcon()
        let titleLabel = initTitle()
        let messageLabel = initMessage()
        let copyButton = initButton(withPrototype: copyButton)
        let dismissButton = initButton(withPrototype: dismissButton)
        
        let views = ["icon": iconImageView, "title": titleLabel, "message": messageLabel]
        let metrics = [
            "iconTop": Message.Padding,
            "titleTop": Message.Padding,
            "right": Message.Padding,
            "bottom": Message.Padding,
            "messageLeft": Message.Padding + Message.MessageOffset,
            "iconLeft": Message.Padding,
            
            "padding": Message.MessageOffset,
            "width": Message.IconSize,
            "height": Message.IconSize
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[icon(==width)]", options: [],
                                                      metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[icon(==height)]", options: [],
                                                      metrics: metrics, views: views))        
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-iconLeft-[icon]-messageLeft-[title]-right-|",
                                                      options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-iconLeft-[icon]-messageLeft-[message]-right-|",
                                                      options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-titleTop-[title]-padding-[message]-bottom-|",
                                                      options: [], metrics: metrics, views: views))
        addConstraints([
            NSLayoutConstraint(item: copyButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: copyButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: copyButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.5, constant: 30.0),
            NSLayoutConstraint(item: copyButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: dismissButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0.0),
            NSLayoutConstraint(item: dismissButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.5, constant: 30.0),
            NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            ])
        
        if let message = message where !message.isEmpty {
            addConstraint(NSLayoutConstraint(item: iconImageView,
                                             attribute: NSLayoutAttribute.centerY,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: messageLabel,
                                             attribute: NSLayoutAttribute.centerY,
                                             multiplier: (title?.isEmpty ?? true) ? 1 : 0.8,
                                             constant: 0))
        } else if let title = title where !title.isEmpty {
            addConstraint(NSLayoutConstraint(item: iconImageView,
                                             attribute: NSLayoutAttribute.centerY,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: titleLabel,
                                             attribute: NSLayoutAttribute.centerY,
                                             multiplier: 1.0,
                                             constant: 0))
        }        
    }    

    private func initIcon() -> UIImageView {
        let iconImageView = UIImageView()
        iconImageView.image = icon
        iconImageView.usesAutoLayout(true)
        addSubview(iconImageView)
        return iconImageView
    }

    private func initTitle() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.usesAutoLayout(true)
        addSubview(titleLabel)
        
        if let title = title {
            let attributes = [
                NSFontAttributeName : titleFont,
                NSForegroundColorAttributeName: titleFontColor,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            titleLabel.attributedText = AttributedString(string: title, attributes: attributes)
        }
        return titleLabel
    }

    private func initMessage() -> UILabel {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.usesAutoLayout(true)
        addSubview(messageLabel)
        
        if let message = message {
            let attributes = [
                NSFontAttributeName : messageFont,
                NSForegroundColorAttributeName: messageFontColor,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            messageLabel.attributedText = AttributedString(string: message, attributes: attributes)
        }
        return messageLabel
    }
    
    private func initButton(withPrototype button: UIButton) -> UIButton {
        button.usesAutoLayout(true)
        addSubview(button)
        return button
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [],
                                                                 metrics: nil, views: ["view": self]))
        super.updateConstraints()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: statusBarFrame.width, height: estimatedHeight)
    }
    
    var estimatedHeight: CGFloat {
        if icon != nil {
            return max(Message.Padding * 2 + titleSize.height + messageSize.height + statusBarOffset,
                       Message.Padding * 2 + Message.IconSize + statusBarOffset)
            
        } else {
            return Message.Padding * 2 + titleSize.height + messageSize.height + statusBarOffset
        }
    }
    
    var titleSize: CGSize {
        let boundedSize = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
        let titleFontAttributes = [NSFontAttributeName: titleFont!]
        if let size = title?.boundingRect(with: boundedSize,
                                          options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin],
                                          attributes: titleFontAttributes, context: nil).size {
            return CGSize(width: ceil(size.width), height: ceil(size.height))
        }
        return CGSize.zero
    }
    
    var messageSize: CGSize {
        let boundedSize = CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude)
        let titleFontAttributes = [NSFontAttributeName: messageFont!]
        if let size = message?.boundingRect(with: boundedSize,
                                            options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin],
                                            attributes: titleFontAttributes, context: nil).size {
            return CGSize(width: ceil(size.width), height: ceil(size.height))
        }
        return CGSize.zero
    }
    
    var statusBarOffset: CGFloat {
        return statusBarFrame.height
    }
    
    var width: CGFloat {
        return statusBarFrame.width
    }
    
    var statusBarFrame: CGRect {
        let windowFrame = UIApplication.shared().keyWindow!.frame
        let statusFrame = UIApplication.shared().statusBarFrame
        return CGRect(x: windowFrame.minX, y: windowFrame.minY, width: windowFrame.width, height: statusFrame.height)
    }
    
    var availableWidth: CGFloat {
        return width - Message.Padding * 2 - Message.IconSize
    }
  
}

extension Message: Identifiable {
  
    internal func id() -> UUID {
      return uuid
    }
  
}

extension UIView {
    
    func usesAutoLayout(_ usesAutoLayout: Bool) {
        translatesAutoresizingMaskIntoConstraints = !usesAutoLayout
    }
    
}

extension UIButton {
    internal class func messageButton(type: UIButtonType) -> UIButton {
        let button = UIButton(type: type)
        button.backgroundColor = .clear()
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    } 
}
