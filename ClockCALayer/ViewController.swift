//
//  Clock2ViewController.swift
//  CarAnimation
//
//  Created by Jimmy Hoang on 2/13/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    let subLayer = CAShapeLayer()
    let secondLayer = CAShapeLayer()
    let minuteLayer = CAShapeLayer()
    let hourLayer = CAShapeLayer()
    let attributes = [
        NSFontAttributeName: UIFont(name: "Helvetica", size:14),
        NSForegroundColorAttributeName: UIColor.black
    ]
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animID = anim.value(forKey: "secAnimID") {
            if animID as! String == "secAnim" {
                secondLayer.removeAnimation(forKey: "secondAnimation")
                updateSecondAnimation()
            }
        }
        
        if let animID = anim.value(forKey: "minAnimID") {
            if animID as! String == "minAnim" {
                minuteLayer.removeAnimation(forKey: "minuteAnimation")
                updateMinuteAnimation()
            }
        }
        
        if let animID = anim.value(forKey: "hourAnimID") {
            if animID as! String == "hourAnim" {
                print("hour called")
                hourLayer.removeAnimation(forKey: "hourAnimation")
                updateHourAnimation()
            }
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("ANIMATION DID START!");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subLayer.path = UIBezierPath(ovalIn: CGRect(x: -150.0 / 2, y: -150.0 / 2, width: 150, height: 150)).cgPath
        subLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        subLayer.fillColor = UIColor.white.cgColor
        subLayer.strokeColor = UIColor.black.cgColor
        subLayer.position = self.view.center
        subLayer.rasterizationScale = UIScreen.main.scale // Make layer smooth
        subLayer.shouldRasterize = true // Make layer smooth
        self.view.layer.addSublayer(subLayer)
        
        for i in 1 ... 30 {
            let firstTick = CAShapeLayer()
            firstTick.path = UIBezierPath(rect: CGRect(x: -150 / 2, y: 0, width: 150, height: 1)).cgPath
            firstTick.transform = CATransform3DMakeRotation(CGFloat((6 * i).degreesToRadians), 0, 0, 1)
            firstTick.fillColor = UIColor.black.cgColor
            firstTick.position = self.view.center
            self.view.layer.addSublayer(firstTick)
        }
        
        let bottomLayer = CAShapeLayer()
        bottomLayer.path = UIBezierPath(ovalIn: CGRect(x: -135.0 / 2, y: -135.0 / 2, width: 135, height: 135)).cgPath
        bottomLayer.position = self.view.center
        bottomLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bottomLayer.fillColor = UIColor.white.cgColor
        self.view.layer.addSublayer(bottomLayer)
        
        for i in 1 ... 6 {
            let firstTick = CAShapeLayer()
            firstTick.path = UIBezierPath(rect: CGRect(x: -150 / 2, y: 0, width: 150, height: 1)).cgPath
            firstTick.transform = CATransform3DMakeRotation(CGFloat((30 * i).degreesToRadians), 0, 0, 1)
            firstTick.fillColor = UIColor.black.cgColor
            firstTick.position = self.view.center
            
            self.view.layer.addSublayer(firstTick)
        }
        
        let topLayer = CAShapeLayer()
        topLayer.path = UIBezierPath(ovalIn: CGRect(x: -120.0 / 2, y: -120.0 / 2, width: 120, height: 120)).cgPath
        topLayer.position = self.view.center
        topLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        topLayer.fillColor = UIColor.white.cgColor
        self.view.layer.addSublayer(topLayer)
        
        secondLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 68, height: 1)).cgPath
        secondLayer.fillColor = UIColor.red.cgColor
        secondLayer.position = self.view.center
        secondLayer.rasterizationScale = UIScreen.main.scale
        secondLayer.shouldRasterize = true
        self.view.layer.addSublayer(secondLayer)
        
        minuteLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 55, height: 2)).cgPath
        minuteLayer.fillColor = UIColor.black.cgColor
        minuteLayer.position = self.view.center
        minuteLayer.rasterizationScale = UIScreen.main.scale
        minuteLayer.shouldRasterize = true
        self.view.layer.addSublayer(minuteLayer)
        
        hourLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 40, height: 2)).cgPath
        hourLayer.fillColor = UIColor.black.cgColor
        hourLayer.position = self.view.center
        hourLayer.rasterizationScale = UIScreen.main.scale
        hourLayer.shouldRasterize = true
        self.view.layer.addSublayer(hourLayer)
        
        let middlePoint = CAShapeLayer()
        middlePoint.path = UIBezierPath(ovalIn: CGRect(x: -10 / 2, y: -10 / 2, width: 10, height: 10)).cgPath
        middlePoint.fillColor = UIColor.black.cgColor
        middlePoint.position = self.view.center
        middlePoint.rasterizationScale = UIScreen.main.scale
        middlePoint.shouldRasterize = true
        self.view.layer.addSublayer(middlePoint)
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.second, .minute, .hour], from: Date())
        
        let seconds = Double(dateComponents.second!)
        let minutes = Double(dateComponents.minute!)
        let hours = Double(dateComponents.hour!)
        // caculated angle
        let secondAngle: CGFloat = caculateSecondDegree(second: seconds)
        let minuteAngle: CGFloat = caculateMinuteDegree(minute: minutes)
        let hourAngle: CGFloat = caculateHourDegree(hour: hours, minute: minutes)
        
        secondLayer.transform = CATransform3DMakeRotation(secondAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        minuteLayer.transform = CATransform3DMakeRotation(minuteAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        hourLayer.transform = CATransform3DMakeRotation(hourAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        
        setupText()
        
        updateSecondAnimation()
        updateMinuteAnimation()
        updateHourAnimation()
        
    }
    
    func setupText() {
        let num12 = CATextLayer()
        let num12AttributesString = NSAttributedString(string: "12", attributes: attributes)
        num12.string = num12AttributesString
        num12.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        num12.position = CGPoint(x: self.view.frame.midX + 2, y: self.view.frame.midY - 83)
        self.view.layer.addSublayer(num12)
        
        let num1 = CATextLayer()
        let num1AttributesString = NSAttributedString(string: "1", attributes: attributes)
        num1.string = num1AttributesString
        num1.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num1.position = CGPoint(x: self.view.frame.midX + 44, y: self.view.frame.midY - 73)
        self.view.layer.addSublayer(num1)
        
        let num2 = CATextLayer()
        let num2AttributesString = NSAttributedString(string: "2", attributes: attributes)
        num2.string = num2AttributesString
        num2.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num2.position = CGPoint(x: self.view.frame.midX + 78, y: self.view.frame.midY - 41)
        self.view.layer.addSublayer(num2)
        
        let num3 = CATextLayer()
        let num3AttributesString = NSAttributedString(string: "3", attributes: attributes)
        num3.string = num3AttributesString
        num3.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num3.position = CGPoint(x: self.view.frame.midX + 86, y: self.view.frame.midY + 2)
        self.view.layer.addSublayer(num3)
        
        let num4 = CATextLayer()
        let num4AttributesString = NSAttributedString(string: "4", attributes: attributes)
        num4.string = num4AttributesString
        num4.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num4.position = CGPoint(x: self.view.frame.midX + 72, y: self.view.frame.midY + 45)
        self.view.layer.addSublayer(num4)
        
        let num5 = CATextLayer()
        let num5AttributesString = NSAttributedString(string: "5", attributes: attributes)
        num5.string = num5AttributesString
        num5.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num5.position = CGPoint(x: self.view.frame.midX + 40, y: self.view.frame.midY + 77)
        self.view.layer.addSublayer(num5)
        
        let num6 = CATextLayer()
        let num6AttributesString = NSAttributedString(string: "6", attributes: attributes)
        num6.string = num6AttributesString
        num6.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num6.position = CGPoint(x: self.view.frame.midX - 1, y: self.view.frame.midY + 89)
        self.view.layer.addSublayer(num6)
        
        let num7 = CATextLayer()
        let num7AttributesString = NSAttributedString(string: "7", attributes: attributes)
        num7.string = num7AttributesString
        num7.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num7.position = CGPoint(x: self.view.frame.midX - 40, y: self.view.frame.midY + 77)
        self.view.layer.addSublayer(num7)
        
        let num8 = CATextLayer()
        let num8AttributesString = NSAttributedString(string: "8", attributes: attributes)
        num8.string = num8AttributesString
        num8.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num8.position = CGPoint(x: self.view.frame.midX - 72, y: self.view.frame.midY + 45)
        self.view.layer.addSublayer(num8)
        
        let num9 = CATextLayer()
        let num9AttributesString = NSAttributedString(string: "9", attributes: attributes)
        num9.string = num9AttributesString
        num9.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        num9.position = CGPoint(x: self.view.frame.midX - 86, y: self.view.frame.midY + 2)
        self.view.layer.addSublayer(num9)
        
        let num10 = CATextLayer()
        let num10AttributesString = NSAttributedString(string: "10", attributes: attributes)
        num10.string = num10AttributesString
        num10.frame = CGRect(x: 0, y: 0, width: 17, height: 20)
        num10.position = CGPoint(x: self.view.frame.midX - 78, y: self.view.frame.midY - 41)
        self.view.layer.addSublayer(num10)
        
        let num11 = CATextLayer()
        let num11AttributesString = NSAttributedString(string: "11", attributes: attributes)
        num11.string = num11AttributesString
        num11.frame = CGRect(x: 0, y: 0, width: 17, height: 20)
        num11.position = CGPoint(x: self.view.frame.midX - 44, y: self.view.frame.midY - 73)
        self.view.layer.addSublayer(num11)
    }
    
    func updateSecondAnimation() {
        let calender = Calendar.current
        let dateComponents = calender.component(.second, from: Date())
        
        let seconds = Double(dateComponents.toIntMax())
        // caculated angle
        let secondAngle: CGFloat = caculateSecondDegree(second: seconds)
        secondLayer.transform = CATransform3DMakeRotation(secondAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        let secondAnimation = CABasicAnimation()
        secondAnimation.setValue("secAnim", forKey: "secAnimID")
        secondAnimation.fillMode = kCAFillModeForwards
        secondAnimation.delegate = self
        secondAnimation.keyPath =  "transform.rotation.z"
        secondAnimation.duration = 60.0 - seconds
        secondAnimation.isRemovedOnCompletion = false
        secondAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        secondAnimation.fromValue = secondAngle - CGFloat(90.degreesToRadians)
        secondAnimation.toValue = CGFloat(270.degreesToRadians)
        
        secondLayer.add(secondAnimation, forKey: "secondAnimation")
    }
    
    func updateHourAnimation() {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.minute, .hour], from: Date())
        let minutes = Double(dateComponents.minute!)
        let hours = Double(dateComponents.hour!)
        
        let hourAngle: CGFloat = caculateHourDegree(hour: hours, minute: minutes)
        hourLayer.transform = CATransform3DMakeRotation(hourAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        let hourAnimation = CABasicAnimation()
        hourAnimation.setValue("hourAnim", forKey: "hourAnimID")
        hourAnimation.fillMode = kCAFillModeForwards
        hourAnimation.delegate = self
        hourAnimation.keyPath =  "transform.rotation.z"
        hourAnimation.duration = (12 - hours) * 60 * 60
        hourAnimation.isRemovedOnCompletion = false
        hourAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        hourAnimation.fromValue = hourAngle - CGFloat(90.degreesToRadians)
        hourAnimation.toValue = CGFloat(270.degreesToRadians)
        
        hourLayer.add(hourAnimation, forKey: "hourAnimation")
    }
    
    func updateMinuteAnimation() {
        let calender = Calendar.current
        let dateComponents = calender.component(.minute, from: Date())
        let minutes = Double(dateComponents.toIntMax())
        
        let minuteAngle: CGFloat = caculateMinuteDegree(minute: minutes)
        minuteLayer.transform = CATransform3DMakeRotation(minuteAngle - CGFloat(90.degreesToRadians), 0, 0, 1)
        let minuteAnimation = CABasicAnimation()
        minuteAnimation.setValue("minAnim", forKey: "minAnimID")
        minuteAnimation.fillMode = kCAFillModeForwards
        minuteAnimation.delegate = self
        minuteAnimation.keyPath =  "transform.rotation.z"
        minuteAnimation.duration = 3600.0 - (minutes * 60.0)
        minuteAnimation.isRemovedOnCompletion = false
        minuteAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        minuteAnimation.fromValue = minuteAngle - CGFloat(90.degreesToRadians)
        minuteAnimation.toValue = CGFloat(270.degreesToRadians)
        
        minuteLayer.add(minuteAnimation, forKey: "minuteAnimation")
    }
    
    func caculateHourDegree(hour: Double, minute: Double) -> CGFloat {
        let degreesPerHour: Double = 30
        let degreePerMinute: Double = 0.5
        
        let hours = hour
        let hoursFor12HourClock = hours < 12 ? hours : hours - 12
        
        let rotationForHoursComponent = hoursFor12HourClock * degreesPerHour
        let rotationForMinutesComponent = degreePerMinute * minute
        
        let totalRotation = rotationForHoursComponent + rotationForMinutesComponent
        
        let hourAngle = totalRotation.degreesToRadians
        
        return CGFloat(hourAngle)
        
    }
    
    func caculateMinuteDegree(minute: Double) -> CGFloat {
        let degreePerMinute: Double = 6
        
        let minuteAngle = (minute * degreePerMinute).degreesToRadians
        
        return CGFloat(minuteAngle)
    }
    
    func caculateSecondDegree(second: Double) -> CGFloat {
        let degreePerSecond: Double = 6
        
        let secondAngle = (second * degreePerSecond).degreesToRadians
        
        return CGFloat(secondAngle)
    }
    
}

