/* Copyright 2018 Infosys Ltd.
Use of this source code is governed by MIT license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

import CouchbaseLiteSwift

var database: Database?

//Method to initialize a cblite db on
@objc(couchbasePlugin) class couchbasePlugin : CDVPlugin {

    override func pluginInitialize() {
        do{
        self.database = DatabaseManager.sharedInstance().database
        }
         catch {
        fatalError(error.localizedDescription);
         }

    }
}

//query to fetch documents
//returns array of data
@objc(selectData:)
func selectData(command: CDVInvokedUrlCommand) {

    let query = QueryBuilder
    .select(SelectResult.all())
    .from(DataSource.database(database))

    do {
    let resultSet = try query.execute()
    let resultSetArray = resultSet.allResults()
    var array = [Any]()
    for item in resultSetArray {
        array.append(item.toDictionary())
    }
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: array)
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    } 
    catch {
    fatalError(error.localizedDescription);
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error Selecting Documents")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}

//Replication
@objc(syncData:)
func syncData(command: CDVInvokedUrlCommand) {

    let syncURL = command.arguments[0] as? String ?? ""
    let syncUserId = command.arguments[1] as? String ?? ""
    let syncPassword = command.arguments[2] as? String ?? ""
    // Create replicators to push and pull changes to and from the cloud.
    let targetEndpoint = URLEndpoint(url: URL(string: syncURL)!)
    let replConfig = ReplicatorConfiguration(database: database, target: targetEndpoint)
    replConfig.replicatorType = .pushAndPull

    // Add authentication.
    replConfig.authenticator = BasicAuthenticator(username: syncUserId, password: syncPassword)

    // Create replicator.
    let replicator = Replicator(config: replConfig)

    // Listen to replicator change events.
    replicator.addChangeListener { (change) in
    if let error = change.status.error as NSError? {
        print("Error code :: \(error.code)")
        }
    }

    // Start replication.
    do{
    replicator.start()
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Sync Started Successfully")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    catch {
    fatalError(error.localizedDescription);
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Sync Error")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}

//Update value of a Key
@objc(updateData:)
func updateData(command: CDVInvokedUrlCommand) {

    let documentId = command.arguments[0] as? String ?? ""
    let keyToUpdate = command.arguments[1] as? String ?? ""
    let valueToSet = command.arguments[2] as? String ?? ""

    if let mutableDoc = database.document(withID: documentId)?.toMutable() {
    mutableDoc.setString(valueToSet, forKey: keyToUpdate)
    do {
    try database.saveDocument(mutableDoc)

    let document = database.document(withID: mutableDoc.id)!
    // Log the document ID (generated by the database)
    print("Document ID :: \(document.id)")
    print("Value \(document.string(forKey: "language")!)")
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Document Updated Successfully")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    } 
    catch {
    fatalError("Error updating document")
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Document Update Failed")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}

//Create Document
@objc(createDocument:)
func createDocument(command: CDVInvokedUrlCommand) {

    let documentId = command.arguments[0] as? String ?? ""
    let JSONString = command.arguments[1] as? String ?? ""
    
    let mutableDoc = MutableDocument(documentId)

    let result = try JSONDecoder().decode([String:Resultat].self, from: JSONString!)
    for (key, value) in result {
    mutableDoc.setString(value, forKey:key)
    }

    // Save it to the database.
    do {
    try database.saveDocument(mutableDoc)
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Document Created Successfully")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    } 
    catch {
    fatalError("Error saving document")
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Document Creation Failed")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}

@objc(deleteDocument:)
func deleteDocument(command: CDVInvokedUrlCommand) {

    let documentId = command.arguments[0] as? String ?? ""

    if let mutableDoc = database.document(withID: documentId)?.toMutable()

    do {
    try database.deleteDocument(mutableDoc)
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Document Deleted Successfully")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    } 
    catch {
    fatalError("Error updating document")
    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Document Deletion Failed")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
}