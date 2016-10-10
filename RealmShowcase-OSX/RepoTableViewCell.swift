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

class RepoTableViewCell: NSTableCellView {

    @IBOutlet var text: NSTextField!
    @IBOutlet var detailText: NSTextField!
    @IBOutlet var image: NSImageView!
    
    fileprivate static let placeholder = NSImage(named: "empty")!
    
    var imageUrl: URL? {
        willSet {
            guard newValue != imageUrl else {return}
            image.setImageWithURL(newValue, placeholder: RepoTableViewCell.placeholder)
        }
    }

    func display(repo: Repository) {
        text.stringValue = repo.name ?? ""
        detailText.stringValue = "\(repo.stars) ⭐️"
        imageUrl = repo.avatarUrl

        if let favorite = repo.favorite {
            text.stringValue += " " + favorite.symbol
        }
    }
}
