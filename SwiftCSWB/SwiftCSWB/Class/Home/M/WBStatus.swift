//
//  WBStatus.swift
//  SwiftCSWB
//
//  Created by LCS on 16/5/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class WBStatus: NSObject{
    
    var idstr : String?
    
    // 重写时间的getter方法
    
    var _created_at : String?
    var created_at : String?{
        set{
            _created_at = newValue
        }
        get{
            /**
            1.今年
            1> 今天
            * 1分内： 刚刚
            * 1分~59分内：xx分钟前
            * 大于60分钟：xx小时前
            
            2> 昨天
            * 昨天 xx:xx
            
            3> 其他
            * xx-xx xx:xx
            
            2.非今年
            1> xxxx-xx-xx xx:xx
            */
            
            // 设置日期格式（声明字符串里面每个数字和单词的含义）
            // E:星期几
            // M:月份
            // d:几号(这个月的第几天)
            // H:24小时制的小时
            // m:分钟
            // s:秒
            // y:年
            
            //_created_at = @"Tue Sep 30 17:06:25 +0600 2014";
            
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            let createdDate : NSDate = dateFormat.dateFromString(_created_at!)!
            let nowDate     = NSDate()
            
            // 日历对象（方便比较两个日期之间的差距）
            let calendar : NSCalendar = NSCalendar.currentCalendar()
            // 计算两个日期之间的差值
            let cmps : NSDateComponents = calendar.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: createdDate, toDate: nowDate, options: NSCalendarOptions(rawValue: 0))
            
            
            
            if (createdDate.isThisYear()) { // 今年
                if (createdDate.isYesterday()) { // 昨天
                    dateFormat.dateFormat = "昨天 HH:mm"
                    return dateFormat.stringFromDate(createdDate)
                } else if (createdDate.isToday()) { // 今天
                    if (cmps.hour >= 1) {
                        return "\(cmps.hour)小时前"
                    } else if (cmps.minute >= 1) {
                        return "\(cmps.minute)分钟前"
                    } else {
                        return "刚刚"
                    }
                } else { // 今年的其他日子
                    dateFormat.dateFormat = "MM-dd HH:mm"
                    return dateFormat.stringFromDate(createdDate)
                }
            } else { // 非今年
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
                return dateFormat.stringFromDate(createdDate)
            }
            
            return _created_at
        }
    }
    
    var id : NSNumber?
    // 重写来源的setter方法
    var _source : String?
    var source : String?{
        
        set{
            _source = newValue
            // where 并且sourceStr 不等于 ""
            if let sourceStr = _source where sourceStr != ""{
                
                // 截取字符串 <a.........>ipone6s</a>
                let startRange = sourceStr.rangeOfString(">")?.startIndex
                // 给startRange增加1
                let startIndex = startRange?.advancedBy(1)
                let endIndex = sourceStr.rangeOfString("</")?.startIndex
                let range = Range(start: startIndex!, end: endIndex!)
                _source = "来自: " + sourceStr.substringWithRange(range)
                
            }
        }
        get{
            return _source
        }
    }
    // 正文
    var text : String?
    
    // 转发微博模型
    var forwordStatus : WBStatus?
    
    // 微博配图大图数组
    var _bmiddle_pic : [NSURL]?
    var bmiddle_pic : [NSURL]?{
        set{
            _bmiddle_pic = newValue
        }
        get{
            var pic_urls : [[String : AnyObject]]?
            if (forwordStatus?.pic_urls != nil && forwordStatus?.pic_urls?.count != 0){
                pic_urls = forwordStatus?.pic_urls
            }else{
                pic_urls = _pic_urls
            }
            
            _bmiddle_pic = [NSURL]()
            
            // 处理大图数组
            for dict in pic_urls!{
                guard var urlStr = dict["thumbnail_pic"] as? String else{
                    continue
                }
                
                urlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                _bmiddle_pic?.append(NSURL(string: urlStr)!)
            }
            
            return _bmiddle_pic
        }
    }
    
    
    // 微博配图(若有转发微博显示转发微博的图片，否则显示原创微博的图片)
    var _pic_urls : [[String : AnyObject]]?
    var pic_urls : [[String : AnyObject]]?{
        set{
            _pic_urls = newValue
            
        }
        get{
            if (forwordStatus?.pic_urls != nil && forwordStatus?.pic_urls?.count != 0){
                return forwordStatus?.pic_urls
            }else{
                return _pic_urls
            }
        }
    }
    
    
    
    // 用户模型
    var user : WBUser?
    // cell高度
    var _cellHeight : CGFloat?
    var cellHeight : CGFloat? {
        get{
            if _cellHeight == nil{
                
                
                // 文字的最大尺寸
                let maxSize = CGSize(width: UIScreen.mainScreen().bounds.width - CGFloat(2 * cellMargin), height: CGFloat(MAXFLOAT))
                
                // 计算转发的高度
                var forwordTextH : CGFloat = 0
                if forwordStatus != nil {
                    
                    if forwordStatus?.text != nil{
                        forwordTextH = ("@\(forwordStatus?.user?.screen_name):\(forwordStatus?.text)" as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
                    }else{
                        forwordTextH = 0
                    }
                }
                
                // 计算文字的高度
                var textH : CGFloat = 0
                if text != nil{
                    textH = (text! as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
                }else{
                    textH = 0
                }
                if forwordStatus != nil {
                    _cellHeight = CGFloat(iconH) + CGFloat(5 * cellMargin)  + textH + CGFloat(bottomBarH) + forwordTextH
                }else{
                    _cellHeight = CGFloat(iconH) + CGFloat(3 * cellMargin)  + textH + CGFloat(bottomBarH)
                }
                
                
                if pic_urls?.count > 0{
                    let picSize = calculateFrame()
                    picF = picSize.0
                    picItemSize = picSize.1
                    forwordBgF = picSize.2
                    _cellHeight = _cellHeight! + (picF?.size.height)! + CGFloat(cellMargin)
                }
            }
            return _cellHeight
        }
    }
    
    // 配图view的frame
    var picF : CGRect?
    
    // 转发微博view的背景frame
    var forwordBgF : CGRect?
    
    // 配图cell的itemSize
    var picItemSize : CGSize?
    
    init(dict : [String : AnyObject]){
        super.init()
    
        setValuesForKeysWithDictionary(dict)
    }
    
    // 对象中的属性和字典不完全匹配的时候要实现该方法，忽略找不到的key
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // KVC 的本质会依次调用该方法。判断若key为user，则转换成WBUser
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "user"{
            let user = WBUser.init(dict: value as! [String : AnyObject])
            self.user = user
            return;
        }
        if key == "retweeted_status" {
            let status = WBStatus.init(dict: value as! [String : AnyObject])
            self.forwordStatus = status
            return;
        }
            
        super.setValue(value, forKey: key)
    }
    
    override var description: String {
        let keys : [String] = ["created_at", "id", "source", "text", "pic_urls"]
        let dict = dictionaryWithValuesForKeys(keys)
        
        return ("\(dict)")
    }
    /**
     获取微博数据
     
     - parameter since_id: 下拉返回比since_id值大的微博
     - parameter max_id: 上拉返回比max_id值小的微博
     - parameter finished: 数据加载完成的回调闭包
     */
    class func loadNewStatuses(max_id : String, since_id : String, finished : (dateArr : [WBStatus]?, error : NSError?) -> ()){
        let URL = "2/statuses/home_timeline.json"
        var params = [String : AnyObject]()
        if let account : WBOAuthAccount? = WBOAuthAccountTool.shareOAuthAccountTool().loadAccount(){
            params["access_token"] = account?.access_token
            params["since_id"] = since_id
            params["max_id"] = max_id
        }
        WBNetworkTool.shareNetworkOAuthTool().GET(URL, parameters: params, success: { (_, response) -> Void in
            
            
            if let JSON = response {
                // 字典数组转模型数组
                let statusArr : [WBStatus] = WBStatus.dictionaryArrToModelArr(JSON["statuses"]! as! [[String : AnyObject]])
                
                // 调用闭包给外部传值
                finished(dateArr: statusArr, error: nil)
            }
            
            }) { (_, error) -> Void in
                // 调用闭包给外部传值
                finished(dateArr: nil, error: error)
        }
    }
    class func dictionaryArrToModelArr(dictArr : [[String : AnyObject]]) -> [WBStatus]{
//        CSprint("----\(dictArr[0])")
        var dateArr = [WBStatus]()
        for dict in dictArr{
            let status : WBStatus = WBStatus.init(dict: dict)
            dateArr.append(status)
        }
        return dateArr
    }
    
    //根据模型计算配图frame、配图cell的itemSize、转发微博背景的frame、
    private func calculateFrame() -> (CGRect , CGSize, CGRect){
        
        let picsW = UIScreen.mainScreen().bounds.width - CGFloat(2 * cellMargin)
        let picsH = picsW
        
        
        // 文字的最大尺寸
        let maxSize = CGSize(width: picsW, height: CGFloat(MAXFLOAT))
        
        // 计算转发的高度
        var forwordTextH : CGFloat = 0
        if forwordStatus != nil {
            
            if forwordStatus?.text != nil{
                forwordTextH = ("@\(forwordStatus?.user?.screen_name):\(forwordStatus?.text)" as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
            }else{
                forwordTextH = 0
            }
        }
        
        // 计算文字的高度
        var textH : CGFloat = 0
        if text != nil{
            textH = (text! as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil).size.height
        }else{
            textH = 0
        }
        
        if pic_urls?.count == 0{
            if forwordStatus != nil{
                return (CGRectZero, CGSizeZero, CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height: CGFloat(2 * cellMargin) + forwordTextH))
            }else{
                return (CGRectZero, CGSizeZero, CGRectZero)
            }
            
        }
        
        // 一张配图
        if pic_urls?.count == 1{
            // 取出缓存中的image计算size
            let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(pic_urls?.first!["thumbnail_pic"] as! String)
            
            var picY : CGFloat = 0
            
            if forwordStatus != nil{
                
                picY = CGFloat(iconH + (5 * cellMargin)) + forwordTextH  + textH
                
                if image != nil {
                    let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: picY, width: image.size.width * 2, height: image.size.height * 2)
                    
                    return (picRect, CGSize(width: image.size.width * 2, height: image.size.height * 2), CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height: image.size.height * 2 + forwordTextH + CGFloat(3 * cellMargin)))
                }else{
                    
                    return (CGRectZero, CGSizeZero, CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height:forwordTextH + CGFloat(3 * cellMargin)))
                }
                
            }else{
                
                picY = CGFloat(iconH + (3 * cellMargin)) + textH
                
                if image != nil {
                    let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: picY, width: image.size.width * 2, height: image.size.height * 2)
                    
                    return (picRect, CGSize(width: image.size.width * 2, height: image.size.height * 2), CGRectZero)
                }else{
                    
                    return (CGRectZero, CGSizeZero, CGRectZero)
                }
                
               
            }
        }else if pic_urls?.count == 4{
            
            let itemSize = (picsW - CGFloat(cellMargin)) / 2
            
            if forwordStatus != nil{
                let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (5 * cellMargin))  + textH + forwordTextH, width: picsW, height: picsH)
                
                return (picRect, CGSize(width: itemSize, height: itemSize), CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height: picsH + forwordTextH + CGFloat(3 * cellMargin)))
            }else{
                let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height: picsH)
                
                return (picRect, CGSize(width: itemSize, height: itemSize), CGRectZero)
            }
            
            
        }else{
            
            let row  = ((pic_urls?.count)! - 1) / 3 + 1
            let col  = ((pic_urls?.count)! - 1) % 3 + 1
            let itemW = (picsW - CGFloat(2 * cellMargin)) / 3
            let itemH = itemW
            
            if forwordStatus != nil{
                
                let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (5 * cellMargin))  + textH + forwordTextH, width: CGFloat(col) * itemW + CGFloat((col - 1) * cellMargin), height: CGFloat(row) * itemH + CGFloat((row - 1) * cellMargin))
                
                return (picRect, CGSize(width: itemW, height: itemH), CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: picsW, height: CGFloat(row) * itemH + CGFloat((row - 1) * cellMargin) + forwordTextH + CGFloat(3 * cellMargin)))
                
            }else{
                let picRect : CGRect = CGRect(x: CGFloat(cellMargin), y: CGFloat(iconH + (3 * cellMargin))  + textH, width: CGFloat(col) * itemW + CGFloat((col - 1) * cellMargin), height: CGFloat(row) * itemH + CGFloat((row - 1) * cellMargin))
                return (picRect, CGSize(width: itemW, height: itemH), CGRectZero)
            }
            
        }
    }
    
}
