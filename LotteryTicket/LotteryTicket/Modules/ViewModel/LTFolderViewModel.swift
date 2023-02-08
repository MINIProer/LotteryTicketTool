//
//  LTFolderViewModel.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/8.
//

import Foundation

struct LTFolderViewModel {
    
    /// 数据源
    var dataSourceArrayM = [LTFolderItemModel]()
    
    //MARK: 配置数据源
    mutating func configDataSource() {
        
        if let path = Bundle.main.path(forResource: "folder_config", ofType: "plist") {
            
            if let array = NSArray(contentsOfFile: path) {
                
                for item in array {
                    
                    let data = try? JSONSerialization.data(withJSONObject: item, options: [])
                    
                    do {
                        let model = try JSONDecoder().decode(LTFolderItemModel.self, from: data!)
                        
                        dataSourceArrayM.append(model)
                        
                    } catch let error {
                        
                        print(error)
                    }
                }
            }
        }
        
        print(dataSourceArrayM)
    }
}
