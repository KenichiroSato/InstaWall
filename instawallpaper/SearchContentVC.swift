//
//  SearchContentVC.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/07/11.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SearchContentVC: ContentBaseVC, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBox: UITextField!
    private let transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = Color.BASE_BLUE
        searchBox.text = "cat"
        photosVC.roadTopSearchItems(searchBox.text)
        addTransparentView()
    }
    
    private func addTransparentView() {
        transparentView.frame = self.view.frame
        transparentView.backgroundColor = Color.BLACK_TRANSPARENT
        transparentView.hidden = true
        self.contentView.addSubview(transparentView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UITextFieldDelegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        transparentView.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        transparentView.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            photosVC.roadTopSearchItems(text)
        }
        closeKeyboard()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeKeyboard()
        super.touchesBegan(touches, withEvent: event)
    }
    
    private func closeKeyboard() {
        searchBox.resignFirstResponder()
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
