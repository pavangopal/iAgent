//
//  PropertyController.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PropertyController: UIViewController {

    lazy var tableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OptionCell.self, forCellReuseIdentifier: String(describing:OptionCell.self))
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    
    var viewModel: PropertyViewModeling!
    var facilityViewModel:[FaciltyUserModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpView()
        
        self.viewModel = PropertyViewModel(apiManager: ApiManager())
        
        setupBindings()
        
    }
    
    func setUpView(){
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
             tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    
    func setupBindings() {
        self.viewModel.getProperty()
        
        self.viewModel.faciltyUserModelObserver.asObservable().subscribe { [weak self] (model) in
            self?.facilityViewModel = model.element
            self?.tableView.reloadData()
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{$0}
            .bind(to: viewModel.cellDidSelect)
            .disposed(by: disposeBag)
        
    }
}

// MARK: - UITableViewDelegate
extension PropertyController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return facilityViewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilityViewModel?[section].options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionCell = tableView.dequeueReusableCell(withIdentifier: String(describing:OptionCell.self), for: indexPath) as! OptionCell
        let option = facilityViewModel?[indexPath.section].options[indexPath.row]
        optionCell.viewModel = option
        return optionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return facilityViewModel?[section].title
    }
    
}


