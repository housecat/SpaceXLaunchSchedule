//
//  CountdowmTImerView.swift
//  SpaceXLaunchSchedule
//
//  Created by Mikhail Kouznetsov on 7/5/19.
//  Copyright © 2019 Mikhail Kouznetsov. All rights reserved.
//

import UIKit

class CountdowmTimerView: UIView {
    
    var seconds:Int!
    var timer:Timer?
    
    private let textView:UILabel = {
        let textView = UILabel()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.semibold)
        textView.textColor = .darkGray
        return textView
    }()
    
    convenience init(){
        self.init( frame:.zero)
        textView.frame = bounds
        addSubview(textView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.frame = bounds
        addSubview(textView)
    }
    
    func setTime(_ seconds:Int){
        self.seconds = seconds
        textView.text = getFormattedString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerTick(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerTick(_ sender:Timer){
        textView.text = getFormattedString()
    }
    
    func getFormattedString() -> String{
        let current = seconds - Int(Date().timeIntervalSince1970)
        if current <= 0 {
            timer?.invalidate()
            timer = nil
            return "LAUNCH!"
        }
        
        let days = current / (60 * 60 * 24)
        let hours = current / (60 * 60) % 24
        let minutes = current / 60 % 60
        let seconds = current % 60
        
        let string = String(format:"%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
        
        return string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
