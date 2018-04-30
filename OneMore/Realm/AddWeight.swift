//
//  AddWeight.swift
//  OneMore
//
//  Created by 池田優作 on 2018/04/26.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import RealmSwift

class AddWeight: Object {
  // 管理用ID。プライマリーキー
  @objc dynamic var id = 0
  
  // UserName
  @objc dynamic var userName = ""
  
  // 日付
  @objc dynamic var time = ""
  
  // 体重
  @objc dynamic var weight = ""
  
  // 日付実数
  @objc dynamic var timeDouble: Double = 0
  
  // 体重実数
  @objc dynamic var weightDouble: Double = 0
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
