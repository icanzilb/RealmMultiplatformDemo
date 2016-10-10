////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////


import UIKit

//
// This controller shows a searcheable list of repos from Realm
// and also updates the peristed repos with latest data from github.
//
class MasterViewController: UITableViewController {

    fileprivate var reposPresenter = ReposListPresenter()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposPresenter.refresh()

        tableView.dataSource = reposPresenter

        //setup search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        //load initial list
        updateSearchResults(for: searchController)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? DetailViewController {
            details.repo = reposPresenter.repos?[tableView.indexPathForSelectedRow!.row]
        }
    }
}

// MARK: - Search Controller
extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        reposPresenter.loadRepos(searchFor: searchController.searchBar.text) {changes in

            switch changes {
                case .initial:
                    self.tableView.reloadData()

                case .update(_, let del, let ins, let upd):
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: ins.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                    self.tableView.reloadRows(at: upd.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                    self.tableView.deleteRows(at: del.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                    self.tableView.endUpdates()

                default: break
            }
        }
    }
}
