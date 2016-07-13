//
//  DownloadingStateDelegate.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

protocol DownloadingStateDelegate: class {
    func didChangeState(newState: DownloadingState, sender: AnyObject)
}
