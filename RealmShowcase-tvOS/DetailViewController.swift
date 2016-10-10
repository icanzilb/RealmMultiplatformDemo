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
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class DetailViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var favorited: UISegmentedControl!
    
    var repo: Repository!
    private let favorites = FavoritesFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = repo.name
        if let url = repo.avatarUrl {
            image.setImageWithURL(url)
        }
        favorited.selectedSegmentIndex = (repo.favorite != nil) ? 1 : 0
    }
    
    @IBAction func toggleFavorite(_ sender: UISegmentedControl) {
        try! favorites.toggle(sender.selectedSegmentIndex == 1, repo: repo)
    }
}
