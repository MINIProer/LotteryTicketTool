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
    
    /// 双色球描述文案
    let desc_ssq: String
    
    /// 大乐透描述文案
    let desc_dlt: String
    
    /// 记录类型
    var recordType: LTRecordType?
    
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
    
    /// 提供给UI展示的描述
    var realShowDesc: String {
        
        let tempDesc = self.recordType == LTRecordType.LTRecordType_SSQ ? desc_ssq : desc_dlt
        
        return tempDesc
    }
}
