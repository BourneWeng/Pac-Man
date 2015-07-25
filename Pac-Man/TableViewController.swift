//
//  TableViewController.swift
//  Pac-Man
//
//  Created by BourneWeng on 15/7/25.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var indicator: PacmanIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = PacmanIndicatorView(frame: CGRectMake(0, 0, self.tableView.bounds.width, 30))
        indicator.center = CGPointMake(CGRectGetMidX(self.tableView.bounds), -50)
        self.tableView.addSubview(indicator)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = max(min(0, scrollView.contentOffset.y), -100)

        indicator.openMouthProgress = abs(offset) / 100
        indicator.hidden = false
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        
        if offset < -100 {
            indicator.startAnimating()
            tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
            
            let time = dispatch_time(DISPATCH_TIME_NOW, 3 * Int64(NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    }, completion: {(finished: Bool) -> Void in
                        self.indicator.stopAnimating()
                        self.indicator.hidden = true
                })
            })
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
