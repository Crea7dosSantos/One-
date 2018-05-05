//
//  FriendViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class FriendViewController: UIViewController {
  @IBOutlet weak var searchTextField: UITextField!
  
  // DB参照作成
  // OneMoreのDatabase上にchildメソッドで値を格納するSearchWordを作成する
  var searchRef = Database.database().reference().child(Search.Friends)
  // 現在ログインしているユーザーの情報を格納する
  let user = Auth.auth().currentUser
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // searchTextFieldの初期設定
      searchTextField.layer.cornerRadius = 5.0
      searchTextField.layer.borderColor = UIColor.lightGray.cgColor
      searchTextField.layer.borderWidth = 1.0
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func searchButton(_ sender: Any) {
    let SearchData = ["Word": searchTextField.text!]
    searchRef.childByAutoId().setValue(SearchData)
    
  }
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
