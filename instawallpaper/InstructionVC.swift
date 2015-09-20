//
//  InstructionVC.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/09/20.
//  Copyright © 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class InstructionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onSwiped(sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func onBackPressed(sender: AnyObject) {
        dismiss()
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
