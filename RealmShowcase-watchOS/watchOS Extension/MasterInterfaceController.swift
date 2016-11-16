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

//
// This controller shows a searcheable list of repos from realm
// and also updates the peristed repos with latest data from github.
//
class MasterInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    private let reposPresenter = ReposListPresenter(provider: GitHubAPI())
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        reposPresenter.refresh(count: 20)
        reposPresenter.loadRepos {[weak self] _ in
            self?.updateUI()
        }
    }

    override func willActivate() {
        super.willActivate()
        updateUI()
    }
    
    func updateUI() {

        if let repositories = reposPresenter.repos {
            table.setNumberOfRows(repositories.count, withRowType: "RepoRowController")

            for (index, repo) in repositories.enumerated() {
                let controller = table.rowController(at: index) as! RepoRowController
                controller.text.setText(repo.nameDecorated)
                controller.detailText.setText(repo.starsDecorated)
            }

            setTitle(reposPresenter.repos!.isEmpty ? "Loading..." : "Repos")
        }

    }
    
    //MARK: - Segues
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return reposPresenter.repos![rowIndex]
    }
}
