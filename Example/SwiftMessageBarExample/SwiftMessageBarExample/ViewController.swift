//
//  Created by Jan Gorman on 10/06/15.
//  Copyright (c) 2015 Schnaub. All rights reserved.
//

import UIKit
import SwiftMessageBar

class ViewController: UIViewController {
    
    private var uuid: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let messageBarConfig = MessageBarConfig(successColor: .orange(), statusBarHidden: true)
        SwiftMessageBar.setSharedConfig(messageBarConfig)
    }
    
    @IBAction func showSuccess(_ sender: AnyObject) {
        let message = "A really long message can go here, to provide a description for the user"
        let copy = UIButton()
        copy.setTitleColor(UIColor.blue(), for: [])
        copy.layer.borderColor = UIColor.blue().cgColor
        copy.setTitle("copy", for: [])
        
        let dismiss = UIButton()
        dismiss.setTitleColor(UIColor.red(), for: [])
        dismiss.layer.borderColor = UIColor.red().cgColor
        dismiss.setTitle("dismiss", for: [])
        //dic: {button: uuid}
        uuid = SwiftMessageBar.showMessageWithTitle(nil, message: message, type: .success, copyButton: copy, dismissButton: dismiss, duration: 3, dismiss: false, callback: nil)
    }

    @IBAction func showError(_ sender: AnyObject) {
        let message = "A really long message can go here, to provide a description for the user, A really long message can go here, to provide a description for the user"
        uuid = SwiftMessageBar.showMessageWithTitle("Error", message: message, type: .error, duration: 3) {
            print("oh hai")
        }
    }

    @IBAction func showInfo(_ sender: AnyObject) {
        let message = "A really long message can go here, to provide a description for the user"
        uuid = SwiftMessageBar.showMessageWithTitle("Info", message: message, type: .info, duration: 3) {
            print("oh hai")
        }
    }

    @IBAction func clearAll(_ sender: AnyObject) {
        SwiftMessageBar.SharedMessageBar.cancelAll(force: true)
        uuid = nil
    }

    @IBAction func clearCurrent(_ sender: AnyObject) {
        if let id = uuid {
            SwiftMessageBar.SharedMessageBar.cancelWithId(id)
            uuid = nil
        }
    }

}
