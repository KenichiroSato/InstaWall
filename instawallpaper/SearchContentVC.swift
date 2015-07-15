//
//  SearchContentVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentVC: ContentBaseVC, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = Color.BASE_BLUE
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            photosVC.roadFromText(text)
        }
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
