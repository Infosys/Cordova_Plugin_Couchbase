/*Copyright 2018 Infosys Ltd.
Use of this source code is governed by MIT license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

var exec = require('cordova/exec');

var couchbasePlugin = {

    selectData: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'couchbasePlugin', 'selectData');
      },

    syncData: function(syncURL, syncUserId, syncPassword, successCallback, errorCallback, ) {
        exec(successCallback, errorCallback, 'couchbasePlugin', 'syncData', [syncURL, syncUserId, syncPassword]);
      },

    updateData:function(documentId, keyToUpdate, valueToSet, successCallback, errorCallback, ) {
        exec(successCallback, errorCallback, 'couchbasePlugin', 'updateData', [documentId, keyToUpdate, valueToSet]);
      },

    createDocument:function(documentId, JSONString, successCallback, errorCallback, ) {
        exec(successCallback, errorCallback, 'couchbasePlugin', 'createDocument', [documentId, JSONString]);
      },

    deleteDocument:function(documentId, successCallback, errorCallback, ) {
        exec(successCallback, errorCallback, 'couchbasePlugin', 'createDocument', [documentId]);
      }

};

module.exports = couchbasePlugin;