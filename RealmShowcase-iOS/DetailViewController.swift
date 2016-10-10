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
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class DetailViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var favorited: UISwitch!
    @IBOutlet var favoriteSymbol: UISegmentedControl!

    var repo: Repository!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = repo.name
        name.text = repo.name
        image.setImageWithURL(repo.avatarUrl)
        favorited.isOn = repo.favorite != nil
        favoriteSymbol.isEnabled = favorited.isOn
        favoriteSymbol.selectedSegmentIndex = repo.favorite?.segmentIndex ?? -1
    }

    @IBAction func toggleFavorite(_ sender: UISwitch) {
        try! repo.toggle(favorite: sender.isOn)

        favoriteSymbol.isEnabled = favorited.isOn
        favoriteSymbol.selectedSegmentIndex = repo.favorite?.segmentIndex ?? -1
    }

    @IBAction func changeSymbol(_ sender: UISegmentedControl) {
        try! repo.favorite?.set(symbol: sender.titleForSegment(at: sender.selectedSegmentIndex))
    }
}
