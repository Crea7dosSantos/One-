//
//  HomeViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/05.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var personalButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  var postArray: [PostData] = []
  
  // DatabaseのobserveEventの登録状態を表す
  var observing = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // tableViewにdelegateとdataSourceを設定する
      tableView.delegate = self
      tableView.dataSource = self
      
      // テーブルセルのタップを無効にする
      tableView.allowsSelection = false
      
      let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
      tableView.register(nib, forCellReuseIdentifier: "Cell")
      
      // テーブルの行の高さをAutoLayoutで自動調整する
      tableView.rowHeight = UITableViewAutomaticDimension
      // テーブルの行の高さの概算値を設定しておく
      // 高さ概算地 = 『縦横比1:1のUIImageViewの高さ(=画面幅)』+ 『イイネボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)』
      tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100

        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("DEBUG_PRINT: viewWillApppear")
    
    if Auth.auth().currentUser != nil {
      if self.observing == false {
        // 要素が追加されたらpostArrayに追加してTableViewを再表示する
        let postRef = Database.database().reference().child(Const.PostPath)
        postRef.observe(.childAdded, with: { snapshot in
          print("DEBUG_PRINT: .childAddedイベントが発生しました.")
          
          // PostDataクラスを生成して受け取ったデータを設定する
          if let uid = Auth.auth().currentUser?.uid {
            let postData = PostData(snapshot: snapshot, myId: uid)
            self.postArray.insert(postData, at: 0)
            
            // TableViewを再表示する
            self.tableView.reloadData()
          }
        })
        // 要素が変更されたら街灯のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
        postRef.observe(.childChanged, with: {snapshot in
          print("DEBUG_PRINT: .childChangedイベントが発生しました。")
          
          if let uid = Auth.auth().currentUser?.uid {
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: uid)
            
            // 保持している配列からidが同じものを探す
            var index: Int = 0
            for post in self.postArray {
              if post.id == postData.id {
                index = self.postArray.index(of: post)!
                break
              }
            }
            
            // 差し変えるため一度削除する
            self.postArray.remove(at: index)
            
            // 削除したところに更新済みのデータを追加する
            self.postArray.insert(postData, at: index)
            
            // TableViewを再表示する
            self.tableView.reloadData()
          }
        })
        
        // DatabaseのobserveEventが上記コードにより登録されたため
        // trueとする
        observing = true
      }
    } else {
      if observing == true {
        // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
        // テーブルをクリアする
        postArray = []
        tableView.reloadData()
        // オブザーバーを削除する
        Database.database().reference().removeAllObservers()
        
        // DatabaseのobserveEventが上記コードにより解除されたため
        // falseとする
        observing = false
        
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // セルを取得してデータを設定する
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
    cell.setPostData(postArray[indexPath.row])
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
    
    return cell
  }
  
  // セル内のボタンがタップされた時に呼ばれるメソッド
  @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
  print("DEBUTG_PRINT: likeボタンがタップされました。")
    
    // タップされたセルのインデックスを求める
    let touch = event.allTouches?.first
    let point = touch!.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: point)
    
    
    
  }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func personalPage(_ sender: Any) {
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
