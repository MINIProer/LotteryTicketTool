//
//  LTResultDataModel.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/2.
//

import Foundation

struct LTResultDataModel: Codable {

    let data: [LTResultDataItemModel]
}

struct LTResultDataItemModel: Codable {
    
    var red_ball_list: [LTBallItemModel]
    var blue_ball_list: [LTBallItemModel]
    
    var lotteryTicketNumber: String {
        var tempString = ""
        
        for itemModel in red_ball_list {
            tempString.append(itemModel.value_string + " ")
        }
        
        for i in 0..<blue_ball_list.count {
            if i == 0 {
                tempString.append(" - ")
            }
            
            let itemModel = blue_ball_list[i]
            
            tempString.append(itemModel.value_string + " ")
        }
        
        return tempString
    }
}

struct LTBallItemModel: Codable {
    
    let value_string: String
}
