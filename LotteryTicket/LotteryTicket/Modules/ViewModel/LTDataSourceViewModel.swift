//
//  LTDataSourceViewModel.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/31.
//

import Foundation

enum LTDataSourceType: Int {
    case LTDataSourceType_SSQ = 0 /// 双色球
    case LTDataSourceType_DLT = 1 /// 大乐透
}

struct LTDataSourceViewModel {
    
    /// 数据源类型
    var dataSourceType: LTDataSourceType?
    
    /// 红球数据源
    var redBallsResultArrayM = [String]()
    
    /// 蓝球数据源
    var blueBallsResultArrayM = [String]()
    
    /// 10次数据源
    var originValueDataSourceDict: [String : [Any]] = [:]
    
    //MARK: < PrivateMethod >
    
    //MARK: 获取一个范围内的随机数
    private func getRandomNumber(from a: Int, to b: Int) -> Int {
        return a + Int(arc4random()) % (b - a + 1)
    }
    
    //MARK: 生成红球数据源
    mutating func fetchRandomRedBallsResult() {
        
        redBallsResultArrayM.removeAll()
        
        let toValue = self.dataSourceType == LTDataSourceType.LTDataSourceType_SSQ ? 33 : 35
        
        let maxCount = self.dataSourceType == LTDataSourceType.LTDataSourceType_SSQ ? 6 : 5
        
        while true {
            let randomValue = getRandomNumber(from: 1, to: toValue)
            let randomValueString = String(format: "%02d", arguments: [randomValue])
            
            if redBallsResultArrayM.count == maxCount {
                break
            }
            
            if !redBallsResultArrayM.contains(randomValueString) {
                redBallsResultArrayM.append(randomValueString)
            }
        }
    }
    
    //MARK: 生成蓝球数据源
    mutating func fetchRandomBlueBallsResult() {
        
        blueBallsResultArrayM.removeAll()
        
        let toValue = self.dataSourceType == LTDataSourceType.LTDataSourceType_SSQ ? 16 : 12
        
        let maxCount = self.dataSourceType == LTDataSourceType.LTDataSourceType_SSQ ? 1 : 2
        
        while true {
            let randomValue = getRandomNumber(from: 1, to: toValue)
            let randomValueString = String(format: "%02d", arguments: [randomValue])
            
            if blueBallsResultArrayM.count == maxCount {
                break
            }
            
            if !blueBallsResultArrayM.contains(randomValueString) {
                blueBallsResultArrayM.append(randomValueString)
            }
        }
    }
    
    mutating func fetchLotteryTicketResult(withTimes times: Int, completionHandle: (LTResultDataModel) -> Void) {
        
        var originValueTempDataSourceArrayM = [[String : [Any]]]()
        
        for _ in 0..<times {
            fetchRandomRedBallsResult()
            fetchRandomBlueBallsResult()
            
            var redBallsTempArrayM = [[String : String]]()
            
            for redValueString in redBallsResultArrayM {
                redBallsTempArrayM.append(["value_string" : redValueString])
            }
            
            var blueBallsTempArrayM = [[String : String]]()
            
            for blueValueString in blueBallsResultArrayM {
                blueBallsTempArrayM.append(["value_string" : blueValueString])
            }
            
            originValueTempDataSourceArrayM.append([
                "red_ball_list" : redBallsTempArrayM,
                "blue_ball_list" : blueBallsTempArrayM
            ])
        }
        
        originValueDataSourceDict["data"] = originValueTempDataSourceArrayM
        
        let data = try? JSONSerialization.data(withJSONObject: originValueDataSourceDict, options: [])
        
        do {
            let model = try JSONDecoder().decode(LTResultDataModel.self, from: data!)
            completionHandle(model)
        } catch let error {
            print(error)
        }
    }
}
