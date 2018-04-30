//
//  LogoutViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/08.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class LogoutViewController: UIViewController {
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBAction func handleLogoutButton(_ sender: Any) {
    // ログアウトする
    try! Auth.auth().signOut()
    
    // ログイン画面を表示する
    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
    self.present(loginViewController!, animated: true, completion: nil)
    
    // ログイン画面から戻ってきた時のためにホーム画面(index = 0)を選択している状態にしておく
    let tabBarController = parent as! ESTabBarController
    tabBarController.setSelectedIndex(0, animated: false)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
