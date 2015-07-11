//
//  SegmentViewController.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/07/09.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SegmentedVC: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    
    static private let titles = ["home", "search"]
    
    static private let TAB_NUM = SegmentedVC.titles.count
    
    private let segmentedControl = HMSegmentedControl(sectionTitles: titles)
    
    var token: dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("headersize=" + NSStringFromCGRect(self.headerView.frame))
        println("contentview=" + NSStringFromCGRect(self.contentView.frame))
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
        println("headersize=" + NSStringFromCGRect(self.headerView.frame))
        println("contentview=" + NSStringFromCGRect(self.contentView.frame))
        dispatch_once(&token) {
            self.setupViews()
            self.setupSubViews()
        }

    }
   
    private func setupViews() {
        segmentedControl.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1)
        segmentedControl.frame = CGRectMake(0, 0, contentWidth(), self.headerView.frame.size.height)
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.selectionIndicatorColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 1)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        segmentedControl.indexChangeBlock = {
            [unowned self] (index: Int) in
            let move = self.contentWidth() * CGFloat(index);
            self.contentView.scrollRectToVisible(CGRectMake(move , 0, self.contentWidth(), self.contentHeight()), animated: true)
        }
        headerView.addSubview(segmentedControl)
        
        contentView.delegate = self
        contentView.contentSize = CGSizeMake(contentWidth() * CGFloat(SegmentedVC.TAB_NUM), contentHeight())
        
    }
    
    private func setupSubViews() {
        println("setupSubViews")

        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotosCollectionVC") as? PhotosCollectionVC {
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            vc.collectionView?.dataSource = vc
            vc.collectionView?.delegate = vc
            vc.view.frame.size = contentView.frame.size
            if let view = vc.view {
                contentView.addSubview(view)
            }
        }
        
        let page2view: UILabel = UILabel(frame: CGRectMake(contentWidth(), 0, contentWidth(), contentHeight()))
        page2view.backgroundColor = UIColor.greenColor()
        contentView.addSubview(page2view)
    }
    
    private func contentWidth() -> CGFloat {
        return contentView.frame.size.width
    }
    
    private func contentHeight() -> CGFloat {
        return contentView.frame.size.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.view.frame.size.width
        let page = contentView.contentOffset.x / pageWidth
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
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
