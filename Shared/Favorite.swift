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

class Favorite: Object {
    
    //persisted property
    dynamic var symbol = "💖"

    var symbolIndex: Int? {
        return ["💖", "🚀", "🤕"].index(of: symbol)
    }

    static let noSymbolIndex = -1
}

// MARK: - Favorite model methods

extension Favorite {
    func set(symbol newSymbol: String?) throws {
        guard let realm = realm, let symbol = newSymbol else { return }

        try realm.write {
            self.symbol = symbol
        }
    }
}
