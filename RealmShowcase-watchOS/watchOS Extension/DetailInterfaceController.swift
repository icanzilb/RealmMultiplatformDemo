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

import WatchKit
import Foundation
import RealmSwift

//
// This controller shows displays a single repo details and
// allows the user to mark it as favorite
//
class DetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var name:  WKInterfaceLabel!
    @IBOutlet weak var stars: WKInterfaceLabel!
    @IBOutlet weak var favorited: WKInterfaceSwitch!
    
    private var repo: Repository!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let repo = context as? Repository {
            self.repo = repo
            self.image.setImageWithURL(repo.avatarUrl, placeholder: UIImage(named: "loading")!)
            name.setText(repo.name)
            stars.setText(repo.starsDecorated)
            favorited.setOn(repo.favorite != nil)
        }
    }
    
    @IBAction func toggleFavorite(_ sender: WKInterfaceSwitch) {
        try! repo.toggle(favorite: (repo.favorite == nil))
    }
}
