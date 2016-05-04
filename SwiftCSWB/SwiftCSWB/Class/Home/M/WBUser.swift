//
//  WBUser.swift
//  SwiftCSWB
//
//  Created by LCS on 16/5/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBUser: NSObject {

    var id : NSNumber?
    var screen_name : String?
    var profile_image_url : String?
    
    /*
    "allow_all_act_msg" = 1;
    "allow_all_comment" = 1;
    "avatar_hd" = "http://tva3.sinaimg.cn/crop.1.0.1239.1239.1024/99f9e77bjw8f3d39n6gnrj20yi0yfgo7.jpg";
    "avatar_large" = "http://tp4.sinaimg.cn/2583291771/180/5756843714/0";
    "bi_followers_count" = 255;
    "block_app" = 1;
    "block_word" = 0;
    city = 1000;
    class = 1;
    "cover_image" = "http://ww3.sinaimg.cn/crop.0.0.920.300/99f9e77bgw1f2jokra5i2j20pk08cglf.jpg";
    "cover_image_phone" = "http://ww1.sinaimg.cn/crop.0.0.640.640.640/6d4a0c7cjw1f344owlzy4j20e80e8jt9.jpg";
    "created_at" = "Fri Jan 20 17:32:05 +0800 2012";
    "credit_score" = 80;
    description = "\U6027\U60c5\U51b7\U6de1 \U7231\U7761\U89c9";
    domain = "";
    "favourites_count" = 355;
    "follow_me" = 0;
    "followers_count" = 861247;
    following = 1;
    "friends_count" = 267;
    gender = f;
    "geo_enabled" = 0;
    id = 2583291771;
    idstr = 2583291771;
    lang = "zh-cn";
    location = "\U5176\U4ed6";
    mbrank = 6;
    mbtype = 12;
    name = "\U5357\U7a51";
    "online_status" = 0;
    "pagefriends_count" = 0;
    "profile_image_url" = "http://tp4.sinaimg.cn/2583291771/50/5756843714/0";
    "profile_url" = 321887373;
    province = 100;
    ptype = 0;
    remark = "";
    "screen_name" = "\U5357\U7a51";
    star = 0;
    "statuses_count" = 1179;
    urank = 34;
    url = "";
    "user_ability" = 8;
    verified = 1;
    "verified_contact_email" = "";
    "verified_contact_mobile" = "";
    "verified_contact_name" = "";
    "verified_level" = 3;
    "verified_reason" = "\U77e5\U540d\U60c5\U611f\U535a\U4e3b";
    "verified_reason_modified" = "";
    "verified_reason_url" = "";
    "verified_source" = "";
    "verified_source_url" = "";
    "verified_state" = 0;
    "verified_trade" = 1150;
    "verified_type" = 0;
    weihao = 321887373;
    */
    init(dict : [String : AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // 对象中的属性和字典不完全匹配的时候要实现该方法，忽略找不到的key
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys : [String] = ["id", "screen_name", "profile_image_url"]
        let dict = dictionaryWithValuesForKeys(keys)
        
        return ("\(dict)")
    }
    
}
