//
//  NSDate+Calculate.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation

extension NSDate{
    
    func isThisYear() -> Bool{
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        // 获得某个时间的年月日时分秒
        let dateCmp : NSDateComponents = calendar.components([.Year], fromDate: self)
        let nowCmp  : NSDateComponents = calendar.components([.Year], fromDate: NSDate())
        return dateCmp.year == nowCmp.year;
    }
    
    func isToday() -> Bool{
        let fmt : NSDateFormatter = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd";
        
        let dateStr : String = fmt.stringFromDate(self)
        let nowStr : String  = fmt.stringFromDate(NSDate())
        
        return (dateStr as NSString).isEqualToString(nowStr);
    }
    
    
    func isYesterday() -> Bool{
        
        
        
        let fmt : NSDateFormatter = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd";
        
        let dateStr : String = fmt.stringFromDate(self)
        let nowStr : String  = fmt.stringFromDate(NSDate())
        
        
        let date : NSDate = fmt.dateFromString(dateStr)!
        let now  : NSDate = fmt.dateFromString(nowStr)!
        
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let cmps : NSDateComponents = calendar.components([.Year,.Month,.Day], fromDate: date, toDate: now, options: NSCalendarOptions(rawValue: 0))
        
        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
    }
    
    
}