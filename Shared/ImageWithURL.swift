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
// Adds a method to all image view classes to load
// and image from a URL and display it
//

#if os(watchOS)
import WatchKit
extension WKInterfaceImage {
    func setImageWithURL(_ url: URL?, placeholder: UIImage? = nil) {
        guard let url = url else {
            setImage(nil)
            return
        }

        setImage(placeholder)
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] data, response, error in
            if let data = data {
                DispatchQueue.main.async(execute: {
                    self?.setImage(UIImage(data: data))
                })
            }
        }) .resume()
    }
}
#else

#if os(iOS) || os(tvOS)
import UIKit
typealias Image = UIImage
typealias ImageView = UIImageView
#elseif os(OSX)
import Cocoa
typealias Image = NSImage
typealias ImageView = NSImageView
#endif

extension ImageView {
    func setImageWithURL(_ url: URL?, placeholder: Image? = nil) {
        guard let url = url else {
            image = nil
            return
        }

        image = placeholder
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] data, response, error in
            if let data = data {
                DispatchQueue.main.async(execute: {
                    self?.image = Image(data: data)
                })
            }
        }).resume()
    }
}
#endif
