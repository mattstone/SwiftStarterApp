//
//  AVPlayerViewController+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import AVKit

extension AVPlayerViewController {
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed == false {
            return
        }
        SSPConfig.sharedInstance.nc.post(name: SSPConfig.sharedInstance.notifiers.SSP_DID_DISMISS_VIDEO_VC, object: nil)
    }
}
