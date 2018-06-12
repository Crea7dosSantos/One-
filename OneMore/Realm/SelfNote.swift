//
//  SelfNote.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/29.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import RealmSwift

class SelfNote: Object {
  // 管理用 ID。プライマリーキー
  @objc dynamic var id = 0
  
  // userName
  @objc dynamic var userName = ""
  
  // SelfNote
  @objc dynamic var text = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
