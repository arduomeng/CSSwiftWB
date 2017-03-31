//
//  WBSqliteManager.swift
//  SwiftCSWB
//
//  Created by arduomeng on 17/3/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import FMDB

class WBSqliteManager: NSObject {

    static let sqliteManager : WBSqliteManager = WBSqliteManager()
    
    // 创建一个单利
    class func shareSqliteManager () -> WBSqliteManager {
        return sqliteManager
    }
    
    var queue : FMDatabaseQueue?
    
    func openDB(_ dbName : String) {
        
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!;
        path = path.appending("/" + dbName)
        
        print(path)
        
        // 创建数据库
        queue = FMDatabaseQueue(path: path)
        
        // 创建表
        createTable()
    }
    
    private func createTable(){
        
        let sql = "CREATE TABLE IF NOT EXISTS t_status ('status_id' INTEGER NOT NULL PRIMARY KEY, 'status_text' TEXT, 'status_uid' INTEGER, 'status_date' TEXT DEFAULT (datetime('now', 'localtime')));"
        queue?.inDatabase({ (db) in
            if (db?.executeUpdate(sql, withArgumentsIn: nil))!{
                print("创建表成功！")
            }
        })
        
        
    }
}
