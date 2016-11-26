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

import Foundation
import RealmSwift

//
// presents an up to date, sorted and filtered list of repos
// implements cross-platform tabe data source methods
//
class ReposListPresenter: NSObject {

    private var refreshToken: NotificationToken?
    private(set) var repos: Results<Repository>?
    private let provider: RepoProvider

    init(provider: RepoProvider) {
        self.provider = provider
    }

    func refresh(count: Int = 100) {
        provider.getRepos(count: count, Repository.add)
    }

    func loadRepos(searchFor term: String? = nil, updated: @escaping (RealmCollectionChange<Results<Repository>>)-> Void) {
        refreshToken?.stop()
        repos = Repository.all(searchTerm: term)
        refreshToken = repos?.addNotificationBlock(updated)
    }

    deinit {
        refreshToken = nil
    }
}

// MARK: - table data source
#if os(iOS)
    import UIKit
    extension ReposListPresenter: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return repos?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RepoTableViewCell
            cell.display(repo: repos![indexPath.row])
            return cell
        }
    }
#elseif os(tvOS)
    import UIKit
    extension ReposListPresenter: UICollectionViewDataSource {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return repos?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RepoCollectionViewCell
            cell.display(repo: repos![indexPath.item])
            return cell
        }
    }

#elseif os(OSX)
    import Cocoa
    extension ReposListPresenter: NSTableViewDataSource, NSTableViewDelegate {
        func numberOfRows(in tableView: NSTableView) -> Int {
            return repos?.count ?? 0
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let cell = tableView.make(withIdentifier: "Cell", owner: nil) as! RepoTableViewCell
            cell.display(repo: repos![row])
            return cell
        }
    }
#endif

