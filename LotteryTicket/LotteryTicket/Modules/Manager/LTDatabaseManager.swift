//
//  LTDatabaseManager.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/14.
//

import Foundation
import SQLite3

class LTDatabaseManager {
    
    /// 数据库路径
    var dbPath = ""
    
    /// 数据库
    var db: OpaquePointer?
    
    //MARK: < Init >
    
    static let shared = LTDatabaseManager()
    
    private init() {
        fetchCachePath()
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 获取缓存路径
    private func fetchCachePath() {
        if let cachePathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let pathURL = URL(fileURLWithPath: cachePathString).appendingPathComponent("lt.sqlite")
            dbPath = pathURL.path
        }
    }
    
    //MARK: < PublicMethod >
    
    //MARK: 打开数据库
    public func openDB() {
        if sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
            print("数据库打开 -> 成功")
        } else {
            print("数据库打开 -> 失败")
        }
    }
    
    //MARK: 创建表
    public func createTable() {
        let createTableQuery = "CREATE TABLE IF NOT EXISTS lottery (id INTEGER PRIMARY KEY AUTOINCREMENT, item_json_str TEXT, item_type INTEGER)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) == SQLITE_OK {
            print("创建表 -> 成功")
        } else {
            print("创建表 -> 失败")
        }
    }
    
    //MARK: 插入数据
    public func insertToDB(withModel model: LTResultDataItemModel) {
        do {
            let data = try JSONEncoder().encode(model)
            if let jsonString = String(data: data, encoding: .utf8) {
                let insertQuery = "INSERT INTO lottery (item_json_str, item_type) VALUES ('\(jsonString)', \(model.recordType.rawValue))"
                if sqlite3_exec(db, insertQuery, nil, nil, nil) == SQLITE_OK {
                    print("插入数据 -> 成功")
                } else {
                    print("插入数据 -> 失败")
                }
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: 查询全部
    public func queryAll(WithType type: LTRecordType) -> [LTResultDataItemModel]? {
        let selectQuery = "SELECT * FROM lottery where item_type = \(type.rawValue)"
        var statement: OpaquePointer? = nil
        var dataArrayM = [LTResultDataItemModel]()

        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let item_json_str = String(cString: sqlite3_column_text(statement, 1))
                do {
                    let data = item_json_str.data(using: .utf8)!
                    let itemModel = try JSONDecoder().decode(LTResultDataItemModel.self, from: data)
                    dataArrayM.append(itemModel)
                } catch {
                    print(error)
                }
            }
            sqlite3_finalize(statement)
        } else {
            print("查询数据哭 -> 失败")
        }
        
        return dataArrayM
    }
}
