/*Copyright 2018 Infosys Ltd.
Use of this source code is governed by MIT license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

import CouchbaseLiteSwift

class DatabaseManager {

    private static var privateSharedInstance: DatabaseManager?

    var database: Database

    let DB_NAME = "mycblitedb"

    class func sharedInstance() -> DatabaseManager   {
        guard let privateInstance = DatabaseManager.privateSharedInstance else {
            DatabaseManager.privateSharedInstance = DatabaseManager()
            return DatabaseManager.privateSharedInstance!
        }
        return privateInstance
    }

    private init() {
        do {
            let config = DatabaseConfiguration()
            config.encryptionKey = EncryptionKey.password("secretpassword")
            self.database = try Database(name: self.DB_NAME, config: config)
        } catch {
            fatalError("Could not copy database")
        }
    }

}