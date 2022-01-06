//
//  MFMailComposer+Extension.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import MessageUI

extension MFMailComposeViewController {
    static func feedBackMailViewController() -> MFMailComposeViewController? {
        if MFMailComposeViewController.canSendMail() == false { return nil }
        let mailViewController = MFMailComposeViewController()
        let toRecipients = ["324etsushi@gmail.com"]
        let mailSubject = "Feedback（SimpleTuner）"
        mailViewController.setSubject(mailSubject)
        mailViewController.setToRecipients(toRecipients)
        return mailViewController
    }
}
