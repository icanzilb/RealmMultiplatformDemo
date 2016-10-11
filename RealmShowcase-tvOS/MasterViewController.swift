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
// Fetches latest top repos, offers search locally
//
class MasterViewController: UICollectionViewController {

    @IBOutlet weak var searchField: UITextField!
    fileprivate let reposPresenter = ReposListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.addTarget(self, action: #selector(updateSearchResults), for: .editingChanged)

        reposPresenter.refresh()
        collectionView!.dataSource = reposPresenter

        //load initial list
        updateSearchResults()
    }

    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? DetailViewController,
            let row = collectionView?.indexPathsForSelectedItems?.first?.row {

            details.repo = reposPresenter.repos![row]
        }
    }
}

//MARK: - Search Field
extension MasterViewController {
    func updateSearchResults(_ sender: UITextField? = nil) {
        reposPresenter.loadRepos(searchFor: sender?.text) { changes in

            switch changes {
                case .initial:
                    self.collectionView?.reloadData()

                case .update(_, let del, let ins, let upd):
                    let cv = self.collectionView!

                    cv.performBatchUpdates({
                        cv.insertItems(at: ins.map {IndexPath(row: $0, section: 0)})
                        cv.reloadItems(at: upd.map {IndexPath(row: $0, section: 0)})
                        cv.deleteItems(at: del.map {IndexPath(row: $0, section: 0)})
                    }, completion: nil)

                default: break
            }
        }
    }
    
    @IBAction func clearSearchField(_ sender: UIButton) {
        searchField.text = nil
        updateSearchResults()
    }
}

//MARK: - tvOS focus handling
extension MasterViewController {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        UIView.animate(withDuration: 0.2, animations: {
            //previous
            if let previousItem = context.previouslyFocusedView as? RepoCollectionViewCell {
                previousItem.imageView.transform = CGAffineTransform.identity
                previousItem.imageView.layer.borderWidth = 0.0
                previousItem.imageView.layer.cornerRadius = 10.0
            }
            
            //next
            if let nextItem = context.nextFocusedView as? RepoCollectionViewCell {
                nextItem.imageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                nextItem.imageView.layer.borderWidth = 5.0
                nextItem.imageView.layer.cornerRadius = 30.0
            }
        }) 
    }
}
