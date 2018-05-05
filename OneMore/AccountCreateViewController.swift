//
//  AccountCreateViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class AccountCreateViewController: UIViewController {
  @IBOutlet weak var displayNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var mailAddressTextField: UITextField!
  
  @IBAction func handleCreateAcountButton(_ sender: Any) {
    if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
      
      // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
      if address.isEmpty || password.isEmpty || displayName.isEmpty {
        print("DEBUG_PRINT: 何かが空文字です。")
        SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
        return
      }
      
      // HUDで処理中を表示
      SVProgressHUD.show()
      
      // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
      Auth.auth().createUser(withEmail: address, password: password) { user, error in
        if let error = error {
          // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
          print("DEBUG_PRINT: " + error.localizedDescription)
          SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
          return
        }
        print("DEBUG_PRINT: ユーザー作成に成功しました。")
        
        // 表示名を設定する
        let user = Auth.auth().currentUser
        if let user = user {
          let changeRequest = user.createProfileChangeRequest()
          changeRequest.displayName = displayName
          changeRequest.commitChanges { error in
            if let error = error {
              SVProgressHUD.showError(withStatus: "ユーザー作成時にエラーが発生しました。")
              print("DEBUG_PRINT: " + error.localizedDescription)
            }
            print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
            
            // HUDを消す
            SVProgressHUD.dismiss()
            
            // let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "View")
            // self.present(ViewController!, animated: true, completion: nil)
            
            self.dismiss(animated: true, completion: nil)
          }
        } else {
          print("DEBUG_PRINT: displayNameの設定に失敗しました。")
        }
      }
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    // 背景をタップしたらdissmissKeyboardメソッドを呼ぶ様に設定する
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
    
    

        // Do any additional setup after loading the view.
    }
  
  @objc func dismissKeyboard() {
    // キーボードを閉じる
    view.endEditing(true)
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
