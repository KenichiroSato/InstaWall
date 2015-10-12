//
//  SegmentViewController.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/07/09.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SegmentedVC: UIViewController, UIScrollViewDelegate {

    enum Segment {
        case HOME
        case SEARCH
        
        func image() -> UIImage {
            switch(self) {
            case .HOME:
                return UIImage.named("home", size: imageSize)!
            case .SEARCH:
                return UIImage.named("search", size: imageSize)!
            }
        }
        
        func vcIdentifier() -> String {
            switch(self) {
            case .HOME:
                return "HomeContentVC"
            case .SEARCH:
                return "SearchContentVC"
            }
        }
        
        static let allValues = [HOME, SEARCH]
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    
    static private let imageSize = CGSizeMake(36, 27)
    static private let images = [Segment.HOME.image(), Segment.SEARCH.image()]
    
    static private let TAB_NUM = Segment.allValues.count
    
    private let segmentedControl = HMSegmentedControl(sectionImages: images, sectionSelectedImages: images)
    
    var token: dispatch_once_t = 0
    var segments: [UInt: ContentBaseVC] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "applicationDidBecomeActive",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func applicationDidBecomeActive() {
        handleShortcutItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_once(&token) {
            self.setupViews()
            self.setupSubViews()
        }
        handleShortcutItem()
    }
    
    private func handleShortcutItem() {
        if (shouldMove()) {
            move()
        }
    }
    
    private func shouldMove() -> Bool {
        if (contentView == nil) {
            return false
        }
        
        if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return appDelegate.hasShortcutItem()
        }
        return false
    }
    
    private func move() {
        if let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let type = appDelegate.shortcutItem()
            for (index, vc) in segments {
                if (vc.shortcutItemType() == type) {
                    segmentedControl.setSelectedSegmentIndex(index, animated: true)
                    let x = CGFloat(index) * self.contentWidth();
                    self.contentView.scrollRectToVisible(
                        CGRectMake(x , 0, self.contentWidth(), self.contentHeight()), animated: true)
                }
            }
            appDelegate.resetShortcutItem()
        }
    }
   
    private func setupViews() {
        segmentedControl.backgroundColor = Color.BASE_BLUE
        segmentedControl.frame = CGRectMake(0, 0, contentWidth(), self.headerView.frame.size.height)
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.selectionIndicatorColor = Color.BASE_BLUE_SELECTED
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
        contentView.delaysContentTouches = false
        
    }
    
    private func setupSubViews() {
        for (index, segment) in Segment.allValues.enumerate() {
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(segment.vcIdentifier()) as? ContentBaseVC {
                self.addChildViewController(vc)
                vc.didMoveToParentViewController(self)
                vc.view.frame = CGRectMake(CGFloat(index) * contentWidth(), 0, contentWidth(), contentHeight())
                if let view = vc.view {
                    contentView.addSubview(view)
                    segments[UInt(index)] = vc
                }
            }
        }
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
