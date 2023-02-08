//
//  LTFolderItemModel.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/8.
//

import Foundation

struct LTFolderItemModel: Codable {
    
    /// 标题文案
    let title: String
    
    /// 描述文案
    let desc: String
    
    /// 提供给UI展示的标题
    var realShowTitle: String {
        
        guard title.contains("-") else {
            return title
        }
        
        let titleArray = title.components(separatedBy: "-")
        
        guard titleArray.count == 2 else {
            return title
        }
        
        return titleArray.first! + "\n" + titleArray.last!
    }
}
