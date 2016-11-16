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

import Cocoa

//
// Fetches latest top repos, offers search locally
//
class MasterViewController: NSViewController {

    fileprivate var reposPresenter = ReposListPresenter(provider: GitHubAPI())
    private var detailsViewController: RepoDetailViewController!

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsViewController = parent!.childViewControllers.last as! RepoDetailViewController

        // setup model
        reposPresenter.refresh()
        tableView.dataSource = reposPresenter
        tableView.delegate = reposPresenter

        // load initial list
        updateSearchResults()
    }

    @IBAction func selectRow(_ sender: Any?) {
        guard tableView.selectedRow >= 0  else { return }
        detailsViewController.repo = reposPresenter.repos![tableView.selectedRow]
    }
}

// MARK: - Search Field
extension MasterViewController {
    @IBAction func updateSearchResults(_ sender: NSSearchField? = nil) {

        tableView.deselectAll(nil)
        reposPresenter.loadRepos(searchFor: sender?.stringValue ?? "", updated: {changes in

            switch changes {
                case .initial:
                    self.tableView.reloadData()

                case .update(_, let del, let ins, let upd):
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: IndexSet(ins), withAnimation: .slideDown)
                    self.tableView.reloadData(forRowIndexes: IndexSet(upd), columnIndexes: IndexSet(integer: 0))
                    self.tableView.removeRows(at: IndexSet(del), withAnimation: .slideUp)
                    self.tableView.endUpdates()

                default: break
            }

        })
    }
}
