//
//  ViewController.swift
//  PacmanView
//
//  Created by BourneWeng on 15/7/25.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var indicator: PacmanIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = PacmanIndicatorView(frame: CGRectMake(0, 0, 200, 50))
        indicator.center = self.view.center
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //开始和停止动画
        if !indicator.hidden {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
        
        //改变颜色
        indicator.pacmanColor = UIColor.redColor()
        indicator.beansColor = UIColor.greenColor()
    }
}

