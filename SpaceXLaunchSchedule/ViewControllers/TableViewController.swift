//
//  ViewController.swift
//  SpaceXLaunchSchedule
//
//  Created by Mikhail Kouznetsov on 7/5/19.
//  Copyright © 2019 Mikhail Kouznetsov. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    var launches:[LaunchElement] = []
    
    lazy var headerView:CountdownTimerView = {
        let view = CountdownTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ headerView, tableView])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return stackView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(LaunchCell.self, forCellReuseIdentifier: LaunchCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        tableView.scrollsToTop = true
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        APISpaceX.shared.getUpcomingLaunces { [weak self] launches, error in
            guard let launches = launches, error == nil else { return }
            self?.launches = launches
            self?.launches.sort(by: {$0.launchDateUnix < $1.launchDateUnix})
            self?.tableView.reloadData()
        }
        
        setLayout()
    }
    
    func setLayout(){
        stackView.frame = view.bounds
        view.addSubview(stackView)
        headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
}

extension TableViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.reuseIdentifier, for: indexPath) as! LaunchCell
        cell.setData(launches[indexPath.row])
        return cell
    }
}


class LaunchCell:UITableViewCell{
    static let reuseIdentifier:String = "LaunchCell"
    var recycledPartsUsed:Bool = false
    
    private var launch:LaunchElement!{
        didSet{
            nameLabel.text = launch.missionName
            idLabel.text = launch.missionID.first
            timeLabel.text = launch.humanReadableDate
            rocketNameLabel.text = launch.rocket.rocketName.rawValue
            
            if let firstStageReused = launch.rocket.firstStage.cores.first?.reused,
                let secondStageReused = launch.rocket.secondStage.payloads.first?.reused{
                recycledPartsUsed = firstStageReused || secondStageReused
            }
 
            reuseLabel.text = recycledPartsUsed ? "reused" : "new"
        }
    }
    
    lazy var firstLineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ nameLabel, idLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var secondLineStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ rocketNameLabel, reuseLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.axis = .horizontal
        return stackView
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ firstLineStackView, secondLineStackView, timeLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private let idLabel:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let rocketNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reuseLabel:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    func setLayout(){
        
        contentView.addSubview(mainStackView)
        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    func setData(_ launch:LaunchElement){
        self.launch = launch
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

