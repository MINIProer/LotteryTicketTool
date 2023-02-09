//
//  LTDataSourceViewModel.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/31.
//

import Foundation
import UIKit

enum LTDataSourceType: Int {
    case LTDataSourceType_SSQ = 0 /// 双色球
    case LTDataSourceType_DLT = 1 /// 大乐透
}

class LTDataSourceViewModel {
    
    /// 数据源类型
    var dataSourceType: LTDataSourceType?
    
    /// 红球数据源
    var redBallsResultArrayM = [String]()
    
    /// 蓝球数据源
    var blueBallsResultArrayM = [String]()
    
    /// 10次数据源
    var originValueDataSourceDict: [String : [Any]] = [:]
    
    /// 缓存下来的数据源
    var cacheDataSourceModel: LTResultDataModel?
    
    weak var controller: UIViewController?
    
    /// 生成彩票次数
    var times: Int?
    
    //MARK: < PrivateMethod >
    
    //MARK: 获取一个范围内的随机数
    private func getRandomNumber(from a: Int, to b: Int) -> Int {
        return a + Int(arc4random()) % (b - a + 1)
    }
    
    //MARK: 生成红球数据源
    func fetchRandomRedBallsResult() {
        
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
    func fetchRandomBlueBallsResult() {
        
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
    
    //MARK: < PublicMethod >
    
    //MARK: 查询彩票结果列表
    func fetchLotteryTicketResult(withTimes times: Int, completionHandle: (LTResultDataModel) -> Void) {
        
        self.times = times
        
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
            self.cacheDataSourceModel = model
            completionHandle(model)
        } catch let error {
            print(error)
        }
    }
    
    //MARK: 根据索引处理玩法
    func handlePlayWay(withIndex index: Int) -> LTResultDataItemModel? {
        
        var model: LTResultDataItemModel?
        
        switch index {
        case 1:
            model = randomFetchOneResultFromDataSource()
        default:
            self.controller?.view.makeToast("123123123")
            break
        }
        
        return model
    }
    
    //MARK: 玩法一：从数据源中随机找出一个彩票
    private func randomFetchOneResultFromDataSource() -> LTResultDataItemModel? {
        
        guard self.cacheDataSourceModel != nil else {
            assert(false, "缓存数据源为空，请检查")
            return nil
        }
        
        guard self.times != 0 else {
            assert(false, "生成彩票的次数不能为0，请检查")
            return nil
        }
        
        let index = getRandomNumber(from: 0, to: self.times! - 1)
        
        guard index < self.cacheDataSourceModel!.data.count else {
            assert(false, "索引越界，请检查")
            return nil
        }
        
        let resultItemModel = self.cacheDataSourceModel!.data[index]
        
        return resultItemModel
    }
}
