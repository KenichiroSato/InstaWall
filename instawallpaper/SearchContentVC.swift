//
//  SearchContentVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentVC: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var seatchBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.backgroundColor = Color.BASE_BLUE

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
