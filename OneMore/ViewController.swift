//
//  ViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import CLImageEditor

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // currentUserがnilならログインしていない
    if Auth.auth().currentUser == nil {
      // ログインしていない時の処理
      let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
      self.present(loginViewController!, animated: true, completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // tabBarのメソッドをViewDidLoad内で実行する
    setupTab()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupTab() {
    
    // 画像のファイル名を指定してESTabBarControllerを作成する
    let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["management", "camera", "graph"])
    
    // 背景色、選択時の色を設定する
    tabBarController.selectedColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
    tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
    // タブの数を設定
    tabBarController.selectionIndicatorHeight = 3
    
    // 作成したESTabBarControllerを親のViewController(=self)に追加する
    // addChildViewControllerメソッドでViewControllerに表示する
    addChildViewController(tabBarController)
    // tabBarViewに代入する
    let tabBarView = tabBarController.view!
    tabBarView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tabBarView)
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      ])
    tabBarController.didMove(toParentViewController: self)
    
    // タブをタップした時に表示するViewControllerを設定する
    let selfManagementViewController = storyboard?.instantiateViewController(withIdentifier: "Management")
    let selfWeighttDataViewController = storyboard?.instantiateViewController(withIdentifier: "Weight")
    let shareViewController = storyboard?.instantiateViewController(withIdentifier: "Share")
    // let logoutViewController = storyboard?.instantiateViewController(withIdentifier: "Logout")
    // let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
   
     tabBarController.setView(selfManagementViewController, at: 0)
    tabBarController.setView(shareViewController, at: 1)
    tabBarController.setView(selfWeighttDataViewController, at: 2)
    
    /*
    // 真ん中のタブはボタンとして扱う
    tabBarController.highlightButton(at: 1)
    tabBarController.setAction({
      // カメラを指定してピッカーを開く
      // もしカメラが使えるかの判定関数
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        // UIImagePickerControllerのインスタンスを作成
        let pickerController = UIImagePickerController()
        // pickerControllerのsourceTypeを.cameraにする
        pickerController.sourceType = .camera
        // 写真を撮った後の関数にViewControllerを指定する
        pickerController.delegate = self
        // カメラをpresentメソッドで表示させる
        self.present(pickerController, animated: true, completion: nil)
      }
    }, at: 1)
  }
  
  // 写真を撮影/選択した時に呼ばれるメソッド
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    if info[UIImagePickerControllerOriginalImage] != nil {
      // 撮影/選択された画像を取得する
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
      // 後でCLImageEditorライブラリで加工する
      print("DEBUG_PRINT: image = \(image)")
      // CLImageEditorにimageを渡して、加工画面を起動する
      let editor = CLImageEditor(image: image)!
      editor.delegate = self
      picker.pushViewController(editor, animated: true)
    }
  }
  
  // キャンセルした時に呼ばれるDelegate
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // ホーム画面を表示する
    let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "Management") as! UINavigationController
    let viewControllers = navigationController.viewControllers;
    let managementViewController = viewControllers[0] as! SelfManagementViewController;
    
    // dismissメソッドで今開いている画面を閉じる
    self.dismiss(animated: true, completion: nil)
    
  }
  
  // CLImageEditorで加工が終わった時に呼ばれるメソッド
  func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
    // 投稿の画面を開く
    // PostviewControllerのNavigationControllerのidentifierに "Post"を設定する
   let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! UINavigationController
    
    let viewControllers = navigationController.viewControllers;
    let postViewController = viewControllers[0] as! PostViewController;
    
    postViewController.image = image!
    editor.present(navigationController, animated: true, completion: nil)
  }
 */
}
}

