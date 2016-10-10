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

//
// A simple GitHub API client
//
class GitHubAPI {
    
    // gets a list of repo json items from github and converts them to objects
    static func getRepos(count: Int = 100, _ completion: @escaping ([Repository])-> Void) {
        
        let reposUrl = URL(string: "https://api.github.com/search/repositories?q=language:swift&per_page=\(count)")!
        let request = URLRequest(url: reposUrl)
        
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            do {
                if let error = error {
                    throw error
                }
                
                let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let items = response["items"] as! [[String: AnyObject]]
                
                //convert json dictionaries to `Repository` objects
                let repos = items.map {item -> Repository in

                    //create objects like usual
                    let repo = Repository()
                    repo.id = item["id"] as! Int
                    repo.name = item["name"] as? String
                    repo.stars = item["stargazers_count"] as! Int
                    repo.url = item["html_url"] as! String
                    repo.avatarUrlString = (item["owner"] as! [String: AnyObject])["avatar_url"] as? String ?? ""
                    return repo
                }
                
                completion(repos)
                
            } catch (let error as NSError) {
                print("Error: " + error.localizedDescription)
                completion([])
            }
            
        }) .resume()
    }
    
}
