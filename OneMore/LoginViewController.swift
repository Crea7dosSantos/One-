//
//  LoginViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var AppNameLabel: UILabel!
  @IBOutlet weak var mailAddressTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  // ログインボタンをタップした時に呼ばれるメソッド
  @IBAction func handleLoginButton(_ sender: Any) {
    if let address = mailAddressTextField.text, let password = passwordTextField.text {
      
      // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
      if address.isEmpty || password.isEmpty {
        SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
        return
      }
      
      // HUDで処理中を表示
      SVProgressHUD.show()
      
      Auth.auth().signIn(withEmail: address, password: password) { user, error in
        if let error = error {
          print("DEBUG_PRINT: " + error.localizedDescription)
          SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
          return
        } else {
          print("DEBUG_PRINT: ログインに成功しました。")
          
          // HUDを消す
          SVProgressHUD.dismiss()
          
         // 画面を閉じてViewControllerに戻る
         self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }

  
  // アカウント作成ボタンをタップした時に呼ばれるメソッド
  @IBAction func handleCreateAcountButton(_ sender: Any) {
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
      // キーボードの改行ボタンのタイプを変更する
      mailAddressTextField.returnKeyType = .done
      passwordTextField.returnKeyType = .done
      
      // テキストを全消去するボタンを表示
      mailAddressTextField.clearButtonMode = .always
      passwordTextField.clearButtonMode = .always
      
      mailAddressTextField.delegate = self
      passwordTextField.delegate = self
      
      // 背景をタップしたらdissmissKeyboardメソッドを呼ぶ様に設定する
      let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      self.view.addGestureRecognizer(tapGesture)
    }
  
  @objc func dismissKeyboard() {
    // キーボードを閉じる
    view.endEditing(true)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func unwind(_ segue: UIStoryboardSegue) {
    // 他の画面からsegueを使って戻ってきた時に呼ばれる
  }
  
  // キーボードの改行ボタンをタップしたときの処理
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを隠す
    textField.resignFirstResponder()
    return true
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
