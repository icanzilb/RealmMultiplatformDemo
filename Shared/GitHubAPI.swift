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

protocol RepoProvider {
    func updateRepos(count: Int, _ completion: @escaping ([Repository])-> Void)
}

//
// A simple GitHub Search API client
//
class GitHubAPI: RepoProvider {
    
    // gets a list of repos from github and converts them to Repository objects
    func getRepos(count: Int = 100, _ completion: @escaping ([Repository])-> Void) {
        
        let reposUrlString = String(format: "https://api.github.com/search/repositories?q=language:swift&per_page=%d", count)
        let request = URLRequest(url: URL(string: reposUrlString)!)

        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            do {
                if let error = error {
                    throw error
                }
                
                let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let items = response["items"] as! [[String: AnyObject]]
                
                //convert json dictionaries to `Repository` objects
                let repos = items.map {item -> Repository? in

                    guard let id = item["id"] as? Int,
                        let name = item["name"] as? String,
                        let stars = item["stargazers_count"] as? Int,
                        let url = item["html_url"] as? String,
                        let owner = item["owner"] as? [String: AnyObject]
                        else { return nil }

                    //create Repository like usual
                    return Repository(id: id, stars: stars, url: url,
                                      avatarUrlString: owner["avatar_url"] as? String ?? "", name: name)

                }
                .flatMap {$0}
                
                completion(repos)
                
            } catch (let error as NSError) {
                print("Error: " + error.localizedDescription)
                completion([])
            }
            
        }) .resume()
    }
    
}
