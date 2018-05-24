//
//  TotalPhotoUpViewController.swift
//  OneMore
//
//  Created by 池田優作 on 2018/05/07.
//  Copyright © 2018年 yusaku.ikeda. All rights reserved.
//

import UIKit

class TotalPhotoUpViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var dateLabel: UILabel!
  
  var photoInformation: PostData!
  let formatter = DateFormatter()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      imageView.image = photoInformation.image
      textView.text = photoInformation.caption
      formatter.dateFormat = "yyyy/MM/dd HH:mm"
      let dateString = formatter.string(from: photoInformation.date!)
      self.dateLabel.text = dateString
      
      textView.isEditable = false

      print("DEBUG_PRINT:PHOTOUP: \(String(describing: imageView.image))")
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
