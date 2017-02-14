//
//  NSDate+Calculate.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation

extension Date{
    
    func isThisYear() -> Bool{
        let calendar : Calendar = Calendar.current
        // 获得某个时间的年月日时分秒
        let dateCmp : DateComponents = (calendar as NSCalendar).components([.year], from: self)
        let nowCmp  : DateComponents = (calendar as NSCalendar).components([.year], from: Date())
        return dateCmp.year == nowCmp.year;
    }
    
    func isToday() -> Bool{
        let fmt : DateFormatter = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd";
        
        let dateStr : String = fmt.string(from: self)
        let nowStr : String  = fmt.string(from: Date())
        
        return (dateStr as NSString).isEqual(to: nowStr);
    }
    
    
    func isYesterday() -> Bool{
        
        
        
        let fmt : DateFormatter = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd";
        
        let dateStr : String = fmt.string(from: self)
        let nowStr : String  = fmt.string(from: Date())
        
        
        let date : Date = fmt.date(from: dateStr)!
        let now  : Date = fmt.date(from: nowStr)!
        
        let calendar : Calendar = Calendar.current
        let cmps : DateComponents = (calendar as NSCalendar).components([.year,.month,.day], from: date, to: now, options: NSCalendar.Options(rawValue: 0))
        
        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
    }
    
    
}
