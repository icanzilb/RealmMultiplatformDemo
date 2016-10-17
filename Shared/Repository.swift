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
import RealmSwift

class Repository: Object {

    // MARK: - Persisted properties
    
    dynamic var id: Int = 0
    dynamic var stars: Int = 0
    dynamic var url: String = ""
    dynamic var avatarUrlString: String = ""
    
    dynamic var name: String?
    dynamic var favorite: Favorite?
    
    // MARK: - Dynamic non-persisted properties
    
    var avatarUrl: URL? {
        get { return URL(string: avatarUrlString) }
        set { avatarUrlString = avatarUrl?.absoluteString ?? "" }
    }

    var starsDecorated: String {
        return "\(stars) ⭐️"
    }

    var nameDecorated: String {
        guard let name = name else {return ""}
        guard let favorite = favorite else {return name}

        return name + " " + favorite.symbol
    }

    // MARK: - Custom init
    convenience init(id: Int, stars: Int, url: String, avatarUrlString: String, name: String) {
        self.init()
        self.id = id
        self.stars = stars
        self.url = url
        self.avatarUrlString = avatarUrlString
        self.name = name
    }

    // MARK: - Model meta information
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["avatarUrl"]
    }
}

// MARK: - Entity model methods

extension Repository {

    static func all(searchTerm: String? = nil) -> Results<Repository> {
        let realm = try! Realm()
        return realm.objects(Repository.self)
            .filter("name contains[c] %@", searchTerm ?? "")
            .sorted(byProperty: "stars", ascending: false)
    }

    static func add(_ repos: [Repository]) {
        let realm = try! Realm()
        try! realm.write {
            repos.forEach {repo in
                if realm.object(ofType: Repository.self, forPrimaryKey: repo.id) != nil {
                    realm.create(Repository.self, value: repo, update: true)
                } else {
                    realm.add(repo)
                }
            }
        }
    }

    func toggle(favorite isFavorite: Bool) throws {
        guard let realm = realm else { return }

        if isFavorite {
            try realm.write {
                favorite = Favorite()
            }
        } else {
            guard let favorite = favorite else {
                return
            }
            try realm.write {
                realm.delete(favorite)
            }
        }
    }
}
