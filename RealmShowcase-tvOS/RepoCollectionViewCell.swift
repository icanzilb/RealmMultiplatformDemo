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

class RepoCollectionViewCell: UICollectionViewCell {
    
    fileprivate static let placeholder = UIImage(named: "empty")!
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView?.image = RepoCollectionViewCell.placeholder
        imageView?.sizeToFit()
    }
    
    var imageUrl: URL? {
        willSet {
            guard newValue != imageUrl else {return}
            imageView?.setImageWithURL(newValue, placeholder: RepoCollectionViewCell.placeholder)
        }
    }

    func display(repo: Repository) {
        text.text = repo.nameDecorated
        detailText.text = repo.starsDecorated
        imageUrl = repo.avatarUrl
    }
}
