//
//  DetailTableViewController.swift
//  NasaViewer
//
//  Created by Кирилл Дутов on 27.02.2021.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MainTableViewController: UITableViewController {
    
    var nasaObjectsArray = [NasaData]()
    private var filteredNasaObjectsArray = [NasaData]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON()
        setSearchController()
        setSearchBar()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredNasaObjectsArray.count
        }
        return nasaObjectsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NASAMainCell
        
        let object: NasaData
        
        if isFiltering {
            object = filteredNasaObjectsArray[indexPath.row]
        } else {
            object = nasaObjectsArray[indexPath.row]
        }
        
        cell.titleLabel.text = nasaObjectsArray[indexPath.row].title
        
        if nasaObjectsArray[indexPath.row].date_created == nil  {
            cell.dateLabel.isHidden = true
        } else {
            cell.dateLabel.text = "Date: " + nasaObjectsArray[indexPath.row].date_created!
        }
        
        if nasaObjectsArray[indexPath.row].center == nil  {
            cell.centerLabel.isHidden = true
        } else {
            cell.centerLabel.text = "Center: " + nasaObjectsArray[indexPath.row].center!
        }
        
        cell.NASAImageView?.sd_setImage(with: URL(string: nasaObjectsArray[indexPath.row].href!), placeholderImage: UIImage(named: nasaObjectsArray[indexPath.row].href!)
        )
        
        cell.NASAImageView.layer.cornerRadius = 30
        cell.NASAImageView.contentMode = .scaleAspectFill
        cell.NASAImageView.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - Passing Data
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let indexPath = self.tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            
            let detailVC = segue.destination as! DetailTableViewController
            
            detailVC.textViewText = self.nasaObjectsArray[selectedRow].description
            detailVC.dataCreatedText = self.nasaObjectsArray[selectedRow].date_created
            detailVC.titleText = self.nasaObjectsArray[selectedRow].title
            
            detailVC.imageURL = self.nasaObjectsArray[indexPath.row].href
            detailVC.photographerText = self.nasaObjectsArray[indexPath.row].photographer
            detailVC.locationText = self.nasaObjectsArray[indexPath.row].location
            
            detailVC.nasaIDText = self.nasaObjectsArray[indexPath.row].nasa_id
            detailVC.centerText = self.nasaObjectsArray[indexPath.row].center
            detailVC.keywordsTextArray = self.nasaObjectsArray[indexPath.row].keywords
        }
    }
    
    // MARK: - Search setup
    
    fileprivate func setSearchController() {
        
        filteredNasaObjectsArray = nasaObjectsArray
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Please enter your search words"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    fileprivate func setSearchBar() {
        
        searchController.searchBar.scopeButtonTitles = ["All", "Titles", "Keywords", "Center"]
        searchController.searchBar.delegate = self
    }
    
    
    // MARK: - Network Service
    
    private func downloadJSON() {
        
        let url = URL(string: "https://images-api.nasa.gov/search?q=space&media_type=image")
        
        guard let downloadURL = url else {return}
        
        let session = URLSession.shared
        
        session.dataTask(with: downloadURL) { data, response, error in
            
            guard let data = data else {return}
            
            do{
                let myJSON = try JSON(data: data)
                let items = myJSON["collection"]["items"]
                
                for item in items.arrayValue {
                    
                    let title = item["data"][0]["title"].stringValue
                    let nasa_id = item["data"][0]["nasa_id"].stringValue
                    let description = item["data"][0]["description"].stringValue
                    
                    let href = item["links"][0]["href"].stringValue
                    let date_created = item["data"][0]["date_created"].stringValue
                    let center = item["data"][0]["center"].stringValue
                    
                    let location = item["data"][0]["location"].stringValue
                    let photographer = item["data"][0]["photographer"].stringValue
                    let keywords = [item["data"][0]["photographer"].stringValue]
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                    let date = dateFormatter.date(from: date_created)
                    
                    let uiDateFormatter = DateFormatter()
                    uiDateFormatter.dateFormat = "dd MMM, yyyy"
                    let uiDate = uiDateFormatter.string(from: date!)
                    
                    self.nasaObjectsArray.append(NasaData(nasa_id: nasa_id, title: title, date_created: uiDate, media_type: "", href: href, description: description, date_created_sort: date!, center: center, photographer: photographer, location: location, keywords: keywords))
                }
                
                self.nasaObjectsArray.sort(by: { $0.date_created_sort! > $1.date_created_sort! } )
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.nasaObjectsArray)
            } catch{
                print(error)
            }
        }.resume()
    }
}

// MARK: - SearchResults Delegate

extension MainTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredNasaObjectsArray = nasaObjectsArray.filter({ (object: NasaData) -> Bool in
            return object.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

// MARK: - UISearchBar Delegate

extension MainTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        }
   
}
