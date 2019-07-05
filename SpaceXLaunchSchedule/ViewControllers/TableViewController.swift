//
//  ViewController.swift
//  SpaceXLaunchSchedule
//
//  Created by Mikhail Kouznetsov on 7/5/19.
//  Copyright © 2019 Mikhail Kouznetsov. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    lazy var headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .blue
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        tableView.scrollsToTop = true
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.frame = view.bounds
        view.addSubview(stackView)
        headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
}

