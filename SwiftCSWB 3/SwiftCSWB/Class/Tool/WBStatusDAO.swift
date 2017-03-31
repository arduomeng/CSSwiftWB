//
//  WBStatusDAO.swift
//  SwiftCSWB
//
//  Created by arduomeng on 17/3/29.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class WBStatusDAO: NSObject {

    class func loadStatuses(_ since_id : String , max_id : String, finish : @escaping ([[String : AnyObject]]?, _ error : Error?)->()) {
        
        
        // 1.从本地获取数据
        loadCacheStatuses(since_id, max_id: max_id) { (JSONArr) in
            if !JSONArr.isEmpty{
                finish(JSONArr, nil)
                return
            }
            
            // 2.若本地没有数据，从网络获取数据
            let URL = "2/statuses/home_timeline.json"
            var params = [String : AnyObject]()
            if let account : WBOAuthAccount? = WBOAuthAccountTool.shareOAuthAccountTool().loadAccount(){
                params["access_token"] = account?.access_token as AnyObject?
                params["since_id"] = since_id as AnyObject?
                params["max_id"] = max_id as AnyObject?
            }
            
            WBNetworkTool.shareNetworkOAuthTool().get(URL, parameters: params, progress: nil, success: { (dataTask, response) in
                if let JSON = response {
                    
                    let JSONArr : [[String : AnyObject]] = (JSON as! [String : AnyObject])["statuses"] as! [[String : AnyObject]]
                    // 3.缓存网络数据
                    cacheStatuses(statuses: JSONArr)
                    
                    // 调用闭包给外部传值
                    finish(JSONArr, nil)
                }
            }) { (dataTask, error) in
                // 调用闭包给外部传值
                finish(nil, error)
            }
            
        }
        
        
        
    }
    
    class func cacheStatuses(statuses : [[String : Any]]){
        
        
        let sql = "INSERT INTO t_status (status_id, status_text, status_uid) VALUES (?, ?, ?)"
        
        // 0.准备数据
        guard let userID = WBOAuthAccountTool.shareOAuthAccountTool().OAuthAccount?.uid else {
            print("userID is nil")
            return
        }
        
        WBSqliteManager.shareSqliteManager().queue?.inTransaction({ (db, rollback) in
            
            for status in statuses {
                
                // 0.1 微博ID
                guard let statusID = status["id"] else{
                    print("statusID is nil")
                    continue
                }
                // 0.2 微博正文 JSON -> 二进制 -> String
                guard let data = try? JSONSerialization.data(withJSONObject: status, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                    continue
                }
                let text = String(data: data, encoding: String.Encoding.utf8)!
                
                // 1.插入数据库
                do {
                    try db?.executeUpdate(sql, values: [statusID, text, userID])
                    
                } catch {
                    // 插入失败回滚
                    rollback?.pointee = true
                    print(error)
                    break;
                }
            }
            
            
        })
        
        
    }
    
    class func loadCacheStatuses(_ since_id : String , max_id : String, finish : @escaping ([[String : AnyObject]])->()){
        
        // 获取用户ID
        guard let userID = WBOAuthAccountTool.shareOAuthAccountTool().OAuthAccount?.uid else {
            print("userID is nil")
            return
        }
        
        var sql = "SELECT * FROM t_status WHERE status_uid = \(userID) "
        // 下啦
        if Int(since_id)! > 0{
            sql += "AND status_id > \(since_id) "
        }
        if Int(max_id)! > 0{
            sql += "AND status_id < \(max_id) "
        }
        sql += "ORDER BY status_id DESC LIMIT 20"
        
        WBSqliteManager.shareSqliteManager().queue?.inTransaction({ (db, rollback) in
            
            var statuses = [[String : AnyObject]]()
            // 1.插入数据库
            do {
                let result = try db?.executeQuery(sql, values: nil)
                
                while result!.next(){
                    let status_text = result?.string(forColumn: "status_text")
                    
                    // String -> JSON
                    guard let data = status_text?.data(using: String.Encoding.utf8) else{
                        continue
                    }
                    let status : [String : AnyObject]? = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
                    
                    if let statusJson = status {
                        statuses.append(statusJson)
                    }
                }
                
                
            } catch {
                // 插入失败回滚
                rollback?.pointee = true
                print(error)
                return
            }
            
            finish(statuses)
        })
        
    }
    
    class func clearCacheData(){
        
        let threeDate = Date.init(timeIntervalSinceNow: -3 * 24 * 60 * 60)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 数据库默认保持格式 2016-03-31 11:11:11
        let dateString = dateFormatter.string(from: threeDate)
        
        // 清楚3天前的缓存数据
        let sql = "DELETE FROM t_status WHERE status_date < \(dateString)"
        
        WBSqliteManager.shareSqliteManager().queue?.inTransaction({ (db, rollback) in
            
            // 1.插入数据库
            do {
                try db?.executeUpdate(sql, values: nil)
                
            } catch {
                // 失败回滚
                rollback?.pointee = true
                print(error)
            }
        })
    }
    
}
