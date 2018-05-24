//
//  SharePhotoUpViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/24.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class SharePhotoUpViewController: UIViewController {
  @IBOutlet weak var profielImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var fightButton: UIButton!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var fightCountLabel: UILabel!
  @IBOutlet weak var captionView: UITextView!
  @IBOutlet weak var commentTextView: UITextView!
  
  var photoInformation: PostData!
  
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
