//
//  SegmentViewController.swift
//  instawallpaper
//
//  Created by 2ndDisplay on 2015/07/09.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import UIKit

class SegmentViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    
    static private let titles = ["home", "search", "more"]
    
    private let segmentedControl = HMSegmentedControl(sectionTitles: titles)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollWidth: CGFloat = self.view.frame.size.width;
        let scrollHeight: CGFloat = (self.view.frame.size.height - self.headerView.frame.size.height);
        
        segmentedControl.backgroundColor = UIColor.yellowColor()
        segmentedControl.frame = CGRectMake(0, 0, scrollWidth, self.headerView.frame.size.height)
        headerView.addSubview(segmentedControl)
        
        contentView.pagingEnabled = true
        contentView.delegate = self
        contentView.showsHorizontalScrollIndicator = false
        contentView.contentSize = CGSizeMake(scrollWidth * 3, scrollHeight)
        println(self.contentView.frame.size.width)
        let page1view: UILabel = UILabel(frame: CGRectMake(0, 0, scrollWidth, scrollHeight))
        page1view.backgroundColor = UIColor.redColor()
        contentView.addSubview(page1view)

        let page2view: UILabel = UILabel(frame: CGRectMake(scrollWidth, 0, scrollWidth, scrollHeight))
        page2view.backgroundColor = UIColor.greenColor()
        contentView.addSubview(page2view)

        let page3view: UILabel = UILabel(frame: CGRectMake(scrollWidth*2, 0, scrollWidth, scrollHeight))
        page3view.backgroundColor = UIColor.blackColor()
        contentView.addSubview(page3view)
        // Do any additional setup after loading the view.
        
        segmentedControl.indexChangeBlock = {
            [unowned self] (index: Int) in
                let move = scrollWidth * CGFloat(index);
                self.contentView.scrollRectToVisible(CGRectMake(move , 0, scrollWidth, scrollHeight), animated: true)
        }
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
