//
//  SelfManagementViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/03/06.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class SelfManagementViewController: UIViewController {

  @IBOutlet weak var profielView: UIView!
  @IBOutlet weak var postView: UIView!
  @IBOutlet weak var followerViwe: UIView!
  @IBOutlet weak var followView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    // profielViewに枠線を作成する
    // CALayerのインスタンスを作成する
    let profielBorder = CALayer()
    // profielBorderのframeプロパティを指定する
    // profielBorderの上線を作成する
    profielBorder.frame = CGRect(x: 0, y: 0, width: profielView.frame.width, height: 1.0)
    profielBorder.backgroundColor = UIColor.lightGray.cgColor
    
    // profielViewに上線を追加
    profielView.layer.addSublayer(profielBorder)
    
    

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
