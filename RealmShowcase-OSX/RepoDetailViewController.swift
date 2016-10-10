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
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class RepoDetailViewController: NSViewController {
    
    @IBOutlet weak var name: NSButton!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var favorited: NSButton!
    @IBOutlet weak var favoriteSymbol: NSSegmentedControl!

    let favorites = FavoritesFactory()

    var repo: Repository! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        view.isHidden = false
        title = repo.name
        name.title = repo.name ?? ""
        image.setImageWithURL(repo.avatarUrl)
        favorited.state = repo.favorite != nil ? NSOnState : NSOffState
        favoriteSymbol.isEnabled = (favorited.state == NSOnState)
        favoriteSymbol.selectedSegment = repo.favorite?.segmentIndex ?? -1
    }
    
    @IBAction func toggleFavorite(_ sender: NSButton) {
        try! favorites.toggle(isFavorite: sender.state == NSOnState, repo: repo)

        favoriteSymbol.isEnabled = (favorited.state == NSOnState)
        favoriteSymbol.selectedSegment = repo.favorite?.segmentIndex ?? -1
    }

    @IBAction func changeSymbol(_ sender: NSSegmentedControl) {
        try! favorites.set(symbol: sender.label(forSegment: sender.selectedSegment), repo: repo)
    }
    
    @IBAction func openRepo(_ sender: NSButton) {
        NSWorkspace.shared().open(URL(string: repo.url)!)
    }
}
