//
//  MediaDownloadView.swift
//  ChatSecureCore
//
//  Created by Chris Ballinger on 6/12/17.
//  Copyright © 2017 Chris Ballinger. All rights reserved.
//

import UIKit
import OTRAssets

public extension NSError {
    /// Returns true if the message error is caused by automatic downloads being disabled
    public var isAutomaticDownloadError: Bool {
        if self.domain == FileTransferError.errorDomain &&
            self.code == FileTransferError.automaticDownloadsDisabled.errorCode {
            return true
        } else {
            return false
        }
    }
}

public class MediaDownloadView: UIView {
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    public var downloadAction: ((_ view: MediaDownloadView, _ sender: Any) -> ())?
    
    public func setMediaItem(_ mediaItem: OTRMediaItem, message: OTRDownloadMessage) {
        if let error = message.messageError {
            let nsError = error as NSError
            if nsError.isAutomaticDownloadError {
                statusLabel.text = mediaItem.displayText()
            } else {
                statusLabel.text = "⚠️ \(ERROR_STRING())"
            }
        } else {
            statusLabel.text = mediaItem.displayText()
        }
        self.downloadButton.setTitle(DOWNLOAD_STRING(), for: .normal)
        self.downloadButton.isEnabled = true
        
        self.downloadAction = { [weak self] view, sender in
            self?.downloadButton.isEnabled = false
            var xmpp: OTRXMPPManager? = nil
            OTRDatabaseManager.shared.readOnlyDatabaseConnection?.read { transaction in
                guard let thread = message.threadOwner(with: transaction) else { return }
                guard let account = thread.account(with: transaction) else { return }
                xmpp = OTRProtocolManager.shared.protocol(for: account) as? OTRXMPPManager
                xmpp?.fileTransferManager.downloadMediaIfNeeded(message)
            }
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        if let downloadAction = downloadAction {
            downloadAction(self, sender)
        }
    }
    
}
