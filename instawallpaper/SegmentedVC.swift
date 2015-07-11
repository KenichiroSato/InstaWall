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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollWidth: CGFloat = self.view.frame.size.width;
        let scrollHeight: CGFloat = (self.view.frame.size.height - self.headerView.frame.size.height);
        
        segmentedControl.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1)
        segmentedControl.frame = CGRectMake(0, 0, scrollWidth, self.headerView.frame.size.height)
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.selectionIndicatorColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 1)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        segmentedControl.indexChangeBlock = {
            [unowned self] (index: Int) in
            let move = scrollWidth * CGFloat(index);
            self.contentView.scrollRectToVisible(CGRectMake(move , 0, scrollWidth, scrollHeight), animated: true)
        }
        headerView.addSubview(segmentedControl)
        
        contentView.delegate = self
        contentView.contentSize = CGSizeMake(scrollWidth * CGFloat(SegmentedVC.TAB_NUM), scrollHeight)
        
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotosCollectionVC") as? PhotosCollectionVC {
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            vc.collectionView?.dataSource = vc
            vc.collectionView?.delegate = vc
            if let view = vc.view {
                contentView.addSubview(view)
            }
        }

        
        /*
[self.storyboard instantiateViewControllerWithIdentifier:@"PhotosCollectionVC"];
        tableViewController.tableView.delegate = tableViewController;
        [tableViewController.view setFrame:CGRectMake(0,152,320,436)];
        [self addChildViewController:tableViewController];
        [tableViewController didMoveToParentViewController:self];
        [self.view addSubview:tableViewController.view];
*/
        
        /*
        let page1view: UILabel = UILabel(frame: CGRectMake(0, 0, scrollWidth, scrollHeight))
        page1view.backgroundColor = UIColor.redColor()
        contentView.addSubview(page1view)
*/
        let page2view: UILabel = UILabel(frame: CGRectMake(scrollWidth, 0, scrollWidth, scrollHeight))
        page2view.backgroundColor = UIColor.greenColor()
        contentView.addSubview(page2view)

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
