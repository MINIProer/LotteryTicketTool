//
//  String+Extension.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/13.
//

import Foundation
import UIKit

extension String {
    
    //MARK: 复制到粘贴板
    func copyToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
}
