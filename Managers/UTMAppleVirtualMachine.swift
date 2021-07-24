//
// Copyright © 2021 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

@available(macOS 12, *)
@objc class UTMAppleVirtualMachine: UTMVirtualMachine {
    var appleConfig: UTMAppleConfiguration! {
        config as? UTMAppleConfiguration
    }
    
    override static func isAppleVM(forPath path: URL) -> Bool {
        do {
            _ = try UTMAppleConfiguration.load(from: path)
            return true
        } catch {
            return false
        }
    }
    
    override func loadConfiguration(withReload reload: Bool) throws {
        config = try UTMAppleConfiguration.load(from: path!)
    }
    
    override func saveUTM() throws {
        let fileManager = FileManager.default
        let newPath = packageURL(forName: appleConfig.name)
        let savePath: URL
        if let existingPath = path {
            savePath = existingPath
        } else {
            savePath = newPath
        }
        try appleConfig.save(to: savePath)
        if let existingPath = path, existingPath.lastPathComponent != newPath.lastPathComponent {
            try fileManager.moveItem(at: existingPath, to: newPath)
            path = newPath
        } else {
            path = savePath
        }
    }
}
