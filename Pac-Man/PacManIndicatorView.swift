//
//  pacmanIndicatorView.swift
//  pacmanView
//
//  Created by BourneWeng on 15/7/25.
//  Copyright (c) 2015年 Bourne. All rights reserved.
//

import UIKit

class PacmanIndicatorView: UIView {

    var pacmanColor: UIColor! {
        didSet {
            pacmanLayer.fillColor = pacmanColor.CGColor
        }
    }
    var beansColor: UIColor! {
        didSet {
            for bean in beanLayers {
                bean.backgroundColor = beansColor.CGColor
            }
        }
    }
    
    private var dispalyLink: CADisplayLink!
    private var progress: CGFloat = 0
    private var pacmanLayer: CAShapeLayer!
    private var beanLayers: [CALayer]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //吃豆人主体layer
        pacmanLayer = CAShapeLayer()
        pacmanLayer.bounds = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))
        pacmanLayer.position = CGPointMake(CGRectGetWidth(frame) * 0.3, CGRectGetMidY(frame))
        pacmanLayer.fillColor = UIColor(red: 234/255.0, green: 90/255.0, blue: 97/255.0, alpha: 1).CGColor
        self.layer.addSublayer(pacmanLayer)
        
        //吃豆人眼球layer
        let eyeLayer = CALayer()
        eyeLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(pacmanLayer.bounds) * 0.1, CGRectGetWidth(pacmanLayer.bounds) * 0.1)
        eyeLayer.position = CGPointMake(CGRectGetWidth(pacmanLayer.bounds) * 0.6, CGRectGetWidth(pacmanLayer.bounds) * 0.2)
        eyeLayer.backgroundColor = UIColor.blackColor().CGColor
        eyeLayer.cornerRadius = CGRectGetWidth(eyeLayer.bounds) / 2.0
        pacmanLayer.addSublayer(eyeLayer)
        
        //豆子layer
        beanLayers = [CALayer]()
        let count = Int((CGRectGetWidth(frame) - pacmanLayer.position.x) / (CGRectGetWidth(pacmanLayer.bounds) / 1.5)) + 1
        for i in 0..<count {
            let position = CGPointMake(pacmanLayer.position.x + (CGRectGetWidth(pacmanLayer.bounds) / 1.5) * CGFloat(i), pacmanLayer.position.y)
            let beanLayer = CALayer()
            beanLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(pacmanLayer.bounds) * 0.2, CGRectGetWidth(pacmanLayer.bounds) * 0.2)
            beanLayer.position = position
            beanLayer.backgroundColor = UIColor(red: 253/255.0, green: 236/255.0, blue: 155/255.0, alpha: 1).CGColor
            beanLayer.cornerRadius = CGRectGetWidth(beanLayer.bounds) / 2.0
            self.layer.insertSublayer(beanLayer, below: pacmanLayer)
            beanLayers.append(beanLayer)
        }
        
        backgroundColor = UIColor.clearColor()
        clipsToBounds = true
        hidden = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        //使用cos函数保证ratio在0~1之间循环
        let ratio: CGFloat = abs(cos(progress))
        progress += 0.1
        
        let path = UIBezierPath()
        let center = CGPointMake(CGRectGetMidX(pacmanLayer.bounds), CGRectGetMidY(pacmanLayer.bounds))
        path.moveToPoint(center)
        path.addArcWithCenter(CGPointMake(CGRectGetMidX(pacmanLayer.bounds), CGRectGetMidY(pacmanLayer.bounds)), radius: pacmanLayer.bounds.width / 2.0, startAngle:CGFloat(M_PI_4) * ratio, endAngle: -CGFloat(M_PI_4) * ratio, clockwise: true)
        path.closePath()
        pacmanLayer.path = path.CGPath

        //豆子的移动
        for layer in beanLayers {
            layer.position.x -= ((CGRectGetWidth(pacmanLayer.bounds) / 1.5) / (CGFloat(M_PI) / 0.1))
        }
        
        //删除到达吃豆人的豆子
        var firstBean = beanLayers.first
        if firstBean!.position.x <= pacmanLayer.position.x && ratio <= 0.05 {
            beanLayers.removeAtIndex(0)
            firstBean!.removeFromSuperlayer()
            firstBean = nil
        }
        
        //在最后添加新的豆子
        let lastBean = beanLayers.last!
        if lastBean.position.x <= CGRectGetWidth(self.bounds) {
            let newBean = CALayer()
            newBean.bounds = lastBean.bounds
            newBean.position = CGPointMake(lastBean.position.x + (CGRectGetWidth(pacmanLayer.bounds) / 1.5), lastBean.position.y)
            newBean.backgroundColor = lastBean.backgroundColor
            newBean.cornerRadius = lastBean.cornerRadius
            
            self.layer.insertSublayer(newBean, below: pacmanLayer)
            beanLayers.append(newBean)
        }
        
    }
    
    //初始化 beans 的位置
    func resetBeans() {
        for i in 0..<beanLayers.count {
            let position = CGPointMake(pacmanLayer.position.x + (CGRectGetWidth(pacmanLayer.bounds) / 1.5) * CGFloat(i), pacmanLayer.position.y)
            let beanLayer = beanLayers[i]
            
            beanLayer.position = position
        }

    }

    func startAnimating() {
        if dispalyLink == nil {
            dispalyLink = CADisplayLink(target: self, selector: "drawRect:")
            dispalyLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            hidden = false
        }
    }
    
    func stopAnimating() {
        if dispalyLink != nil {
            dispalyLink.invalidate()
            dispalyLink = nil
            
            progress = 0
            drawRect(self.frame)
            
            hidden = true
            
            resetBeans()
        }
    }

}
