//
//  ViewController.swift
//  ImageList
//
//  Created by Sankaranarayana Settyvari on 30/06/20.
//  Copyright © 2020 Sankaranarayana Settyvari. All rights reserved.
//

import UIKit


class ViewController: UIViewController, RestWrapperDelegate {
    
    var tableView = UITableView()
    var rest:RestWrapper = RestWrapper()
    var photoListArray:NSMutableArray = NSMutableArray()
    var progressHUD = ProgressHUD(text:"")
    var progressView: UIView = UIView()
    var screenSize = CGRect(origin: .zero, size: .zero)
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTableView()
        configureRefresh()
        loadPopup()
        
        //======== Calling Rest API to fetch Image details ======================//
        rest.delegate = self
        rest.getPhotosData()
        
    }
    
    //======== Configuring Tableview ======================//
    func configureTableView() {
        
        tableView = UITableView(frame:self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.register(PhotoCell.self, forCellReuseIdentifier: "photoCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    //======== Refresh Tableview ======================//
    func configureRefresh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //======== Displaying Popup for Loading Tableview with Images Info.============//
    func loadPopup()  {
        
        self.screenSize = UIScreen.main.bounds
        self.progressView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height))
        let dimAlphaRedColor =  UIColor.gray.withAlphaComponent(0.5)
        self.progressView.backgroundColor =  dimAlphaRedColor
        self.view.addSubview(self.progressView)
        self.progressHUD = ProgressHUD(text: "Loading Photos List")
        self.progressView.addSubview(self.progressHUD)
    }
    
    @objc func refresh(_ sender: Any) {
        //  your code to reload tableView
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - RestWrapper Delegate
    
    func didReceivePhotosData(arrayList:NSMutableArray, titleString:String) {
        
        self.progressView.removeFromSuperview()
        self.progressHUD.removeFromSuperview()
        
        if arrayList.count > 0
        {
            self.photoListArray.removeAllObjects()
            self.photoListArray.addObjects(from: arrayList as! [Any])

            tableView.reloadData()
            navigationItem.title = titleString
         }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK:- TableView datasource

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        cell.photo = self.photoListArray[indexPath.row] as? Photo
        
        return cell
    }
    
}




