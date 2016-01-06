//
//  CurrencySearchViewController.swift
//  SearchControllerExperiment
//
//  Created by Mark Cornelisse on 03/01/16.
//  Copyright © 2016 Over de muur producties. All rights reserved.
//

import UIKit
import CurrencyConverter

enum CurrencySearchScope: Int {
    case Name = 0, Code
}

class CurrencySearchViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: Properties
    var currencies: [Currency]! {
        didSet {
            let selector: Selector = "name"
            let collation = UILocalizedIndexedCollation.currentCollation()
            sortedCurrencies = collation.sortedArrayFromArray(currencies, collationStringSelector: selector) as! [Currency]
            tableView.reloadData()
        }
    }
    var sortedCurrencies: [Currency]!
    
    var searchController = UISearchController(searchResultsController: nil)
    var filteredCurrencies: [Currency]!
    
    var detailViewController: DetailCurrency? = nil
    
    // MARK: Actions
    
    // MARK: New in this class
    
    func attributedStringForLabel(string: String) -> NSAttributedString {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let attrs = [NSFontAttributeName: font]
        return NSAttributedString(string: string, attributes: attrs)
    }
    
    // MARK: UI Table View Controller
    
    // MARK: UI View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencies = CurrencyController().currencies
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.searchController.searchBar.sizeToFit()
        
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.Automatic
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailCurrency
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        switch (segue.identifier) {
        case let idenfitier where idenfitier == "OpenDetailCurrency":
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let destination = destinationNavigationController.topViewController as! DetailCurrency
            if searchController.active && searchController.searchBar.text != "" {
                let indexPath = self.tableView.indexPathForSelectedRow!
                destination.currency = self.filteredCurrencies[indexPath.row]
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow!
                destination.currency = self.sortedCurrencies[indexPath.row]
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        default:
            print("This should not be happening")
            abort()
        }
    }
    
    // MARK: UI Table View Delegate
    
    // MARK: UI Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCurrencies.count
        } else {
            return sortedCurrencies.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrencyCell")!
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel!.attributedText = attributedStringForLabel(filteredCurrencies[indexPath.row].name)
        } else {
            cell.textLabel!.attributedText = attributedStringForLabel(sortedCurrencies[indexPath.row].name)
        }
        return cell
    }
    
    // MARK: UI Search Results Updating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filteredCurrencies = sortedCurrencies.filter({ (currency) -> Bool in
            return currency.name.lowercaseString.containsString(searchBar.text!.lowercaseString)
        })
        tableView.reloadData()
    }
    
    // MARK: UI Search Bar Delegate
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(self.searchController)
    }
}
