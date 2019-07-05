//
//  CountdowmTImerView.swift
//  SpaceXLaunchSchedule
//
//  Created by Mikhail Kouznetsov on 7/5/19.
//  Copyright © 2019 Mikhail Kouznetsov. All rights reserved.
//

import UIKit

class CountdownTimerView: UIView {
    private var eventTimeSeconds:Int!
    private var timer:Timer?
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "NEXT LAUNCH IN..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 44, weight: UIFont.Weight.semibold)
        label.textColor = .white
        return label
    }()
    
    private let days:UILabel = {
        let label = UILabel()
        label.text = "DAYS"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hours:UILabel = {
        let label = UILabel()
        label.text = "HOURS"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minutes:UILabel = {
        let label = UILabel()
        label.text = "MINUTES"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seconds:UILabel = {
        let label = UILabel()
        label.text = "SECONDS"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    convenience init(){
        self.init( frame:.zero)
        setLayout()
        
        APISpaceX.shared.nextMission { [weak self] launch, error in
            guard let strongSelf = self, let launch = launch, error == nil  else { return }
            strongSelf.setTime(launch.launchDateUnix)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    func setLayout(){
        addSubview(titleLabel)
        addSubview(timerLabel)
        addSubview(days)
        addSubview(hours)
        addSubview(minutes)
        addSubview(seconds)
        
        let guide = safeAreaLayoutGuide
        titleLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        timerLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        
        days.topAnchor.constraint(equalTo: timerLabel.bottomAnchor).isActive = true
        days.leadingAnchor.constraint(equalTo: timerLabel.leadingAnchor, constant: 15).isActive = true
        
        hours.topAnchor.constraint(equalTo: timerLabel.bottomAnchor).isActive = true
        hours.leadingAnchor.constraint(equalTo: days.trailingAnchor, constant: 26).isActive = true
        
        minutes.topAnchor.constraint(equalTo: timerLabel.bottomAnchor).isActive = true
        minutes.leadingAnchor.constraint(equalTo: hours.trailingAnchor, constant: 26).isActive = true
        
        seconds.topAnchor.constraint(equalTo: timerLabel.bottomAnchor).isActive = true
        seconds.leadingAnchor.constraint(equalTo: minutes.trailingAnchor, constant: 12).isActive = true
    }
    
    func setTime(_ seconds:Int){
        self.eventTimeSeconds = seconds
        timerLabel.text = getFormattedString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerTick(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerTick(_ sender:Timer){
        timerLabel.text = getFormattedString()
    }
    
    func getFormattedString() -> String{
        let current = eventTimeSeconds - Int(Date().timeIntervalSince1970)
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
}
