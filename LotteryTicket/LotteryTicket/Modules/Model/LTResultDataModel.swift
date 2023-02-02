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
}

struct LTBallItemModel: Codable {
    
    let value_string: String
}
