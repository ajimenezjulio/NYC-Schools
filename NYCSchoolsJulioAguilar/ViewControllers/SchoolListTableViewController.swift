//
//  SchoolListTableViewController.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import UIKit

class SchoolListTableViewController: UITableViewController, ActivityIndicatorProtocol, UISearchResultsUpdating {
    
    private var schoolListViewModel = SchoolListViewModel()
    
    private var datasource: TableViewDataSource<SchoolTableViewCell, SchoolViewModel>!
    // Our search controller
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Enabling the large title feature
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Building our datasource
        self.datasource = TableViewDataSource(cellIdentifier: kSCHOOLCELL, items: self.schoolListViewModel.schoolViewModels) { cell, vm in
            cell.configure(vm)
        }
        // Telling the TableViewController who is going to be the datasource
        self.tableView.dataSource = self.datasource
        // Setup for searchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        // It notifies when some update is going on
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        // Load the NYC schools
        loadSchools()
    }
    
    // Animation for the table view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable(tableView: self.tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        // Search Bar
        let textField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
        textField?.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Change background
        let backgroundLayer = textField?.subviews.first
        backgroundLayer?.backgroundColor = #colorLiteral(red: 0.205920577, green: 0.6465933919, blue: 0.953766048, alpha: 1)
        backgroundLayer?.layer.cornerRadius = 10;
        backgroundLayer?.clipsToBounds = true
    }
    
    
    // MARK: TableView Delegate Functions
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create the school detailVC
        let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schoolDetail") as! SchoolDetailViewController
        // Pass school to detailVC
        detailVC.schoolVM = self.datasource.items[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    // MARK: Load Data
    func loadSchools() {
        // Start animation and keeping the view references to remove them at the end and avoid mempry leaks
        let viewReferences: [UIView]
        // We need the height of the navigation bar to adjust the activity at the half
        viewReferences = self.showActivityIndicator(navigationHeight: (self.navigationController?.navigationBar.frame.height)!)
        
        // Show message if no data available or reload the data to show the schools
        self.schoolListViewModel.fetchSchools { (noDataMessage) in
            if let message = noDataMessage {
                self.navigationController?.show(message: message)
            }
            self.datasource.updateItems(self.schoolListViewModel.schoolViewModels)
            animateTable(tableView: self.tableView)
            // Remove views
            self.hideActivityIndicator(viewsToDismiss: viewReferences)
        }
    }
    
    
    // MARK: IBActions
    @IBAction func didRefreshTapped(_ sender: Any) {
        loadSchools()
    }
    
    
    // MARK: SearchControllerFunctions
    // Every time the search is updated, this function is called
    func updateSearchResults(for searchController: UISearchController) {
        schoolListViewModel.filterSchools(searchText: searchController.searchBar.text!)
        self.datasource.updateItems(self.schoolListViewModel.filteredSchools)
        self.tableView.reloadData()
    }
}
