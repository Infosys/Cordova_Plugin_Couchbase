“Copyright 2018 Infosys Ltd.
Use of this source code is governed by MIT license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.”

CORDOVA PLUGIN FOR COUCHBASE LITE

Introduction:
This is document is all about some basic understanding of Couchbase, why we need a plugin for Cordova to use Couchbase, how to create a plugin for iOS and Android and sample plugin code for basic CRUD operations.
Why Couchbase?
Today’s mission-critical applications demand support for millions of interactions with end-users. Traditional databases were built for thousands. Designed for consistency and control, they lack agility, flexibility, and scalability. To execute multiple use cases, organizations are forced to deploy multiple types of databases, resulting in a "database sprawl" - and inefficiency, sluggish time to market, and poor customer experience. 

Couchbase Server is an open source, distributed, NoSQL document-oriented engagement database. It exposes a fast key-value store with managed cache for sub-millisecond data operations, purpose-built indexers for fast queries and a powerful query engine for executing SQL-like queries. 

Couchbase Lite for mobile and Internet of Things environments Couchbase also runs natively on-device. This enables the device’s offline capability to ensure the business continuation.

Couchbase Sync Gateway manages data synchronization b/w Couchbase Lite DB on mobile and Couchbase server.

Why Cordova?
Apache Cordova is an open-source mobile development framework. It allows you to use standard web technologies - HTML5, CSS3, and JavaScript for cross-platform development. Applications execute within wrappers targeted to each platform, and rely on standards-compliant API bindings to access each device's capabilities such as sensors, data, network status, etc.
Use Apache Cordova if you are a mobile developer and want to extend an application across more than one platform, without having to re-implement it with each platform's language and tool set.
A Cordova plugin is a package of injected code that allows the Cordova web view within which the app renders to communicate with the native platform on which it runs. Plugins provide access to device and platform functionality that is ordinarily unavailable to web-based apps so all the main Cordova API features are implemented as plugins.
Couchbase with Cordova Architecture:
There are several security components and Integrations in the actual application PoC design, this following diagram just shows a high-level view of what we did for a reputed financial organization to integrate Cordova with Couchbase Lite database on mobile. The user Interface is a web app, the business logic and data model is written in native Swift. The data model uses Couchbase Lite as the embedded data persistence layer. The Cordova Plugin API acts as the bridging layer between the JavaScript and the native Swift worlds. The plugin exposes a JavaScript API to the web app. This architecture allows you to write the User Interface code once for both iOS and Android apps while leveraging Couchbase Lite’s native iOS framework for data management.

 



 
Plugin Development for iOS Step-by-step:
In this section you will create a new plugin called Cordova-plugin-Couchbase to implement data persistence using Couchbase Lite’s Swift API.
The plugin code will be added to the Cordova-plugin-Couchbase folder which resides alongside the Cordova application folder.
Step 1: Create a new file at Cordova-plugin-Couchbase/plugin.xml with the following.











The id="Cordova-plugin-Couchbase" attribute is the plugin name which will be used later to import it in the Cordova project.
The <js-module></js-module> XML tag declares the location of the file that will declare the JavaScript interface.
The <platform name="ios"></platform> XML tag declares the location of the Swift files to hold the native code.





Step 2: Create a new file at Cordova-plugin-Couchbase/package.json with the following









This file describes the plugin.
Step 3: Create a new file at Cordova-plugin-Couchbase/www/Couchbase.js. This file defines the JS API with which a Cordova web app may interact with this plugin. Generally, this means that the plugin binds to the window element and by doing so, grants access to its parent project through simple JavaScript references. Add the following to your Couchbase.js file:





Step 4: Create a new file at Cordova-plugin-Couchbase/src/ios/Couchbase.swift with the following. This file provides the native Swift implementation corresponding to the APIs defined in Couchbase.js.



The Cordova Plugin is instantiated when it is first called in the JavaScipt WebView app. The pluginInitialized() method includes the startup code. 
To verify that your plugin is ready to work as expected, you have to install it in your Couchbase project. To do so, run the following commands from the root of the starter-project folder.
Cordova plugin add ../Cordova-plugin-Couchbase/
Cordova platform add ios
Couchbase Lite Setup:
Next, you will import Couchbase Lite as a dependency in the Xcode project.
Download Couchbase Lite framework from here https://www.couchbase.com/downloads and Unzip the file.
Open the Xcode project located at Couchbase/platforms/ios/Couchbase.xcodeproj.
Drag CouchbaseLiteSwift.framework from the downloaded folder to the Xcode project navigator. Be sure to select the Copy items if needed checkbox.
 
Navigate to Project > General > Embedded Binary and drag CouchbaseLiteSwift.framework over the list.
 
Database Setup:
We will use the singleton pattern to setup the database instance. Create a new file at Cordova-plugin-Couchbase/src/ios/DatabaseManager.swift and insert the following.














When adding a new Swift file, it must be referenced in the plugin’s configuration file. Insert the following as a child to the <platform name="ios"></platform> element in Cordova-plugin-Couchbase/plugin.xml.
<source-file src="src/ios/DatabaseManager.swift"/>
To test your changes, you must re-install the Cordova plugin from Cordova-plugin-Couchbase to Couchbase. Run the following commands from the root of the Cordova application folder.
Cordova emulate ios --target "iPhone-XR, 12.0" -- --buildFlag="-seModernBuildSystem=0"
The application should run successfully the Couchbase Lite database is initialized but you haven’t run any queries to insert / select data from the database.
In the next section, you will use this Database variable to insert & select data from Couchbase Lite database.
Add the implementation of the getdata method to Cordova-plugin-Couchbase/src/ios/Couchbase.swift.













This method queries for all properties of documents including the Document id where the type property is testing.
Next, you will update the plugin’s JavaScript interface. In Cordova-plugin-Couchbase/www/Couchbase.js, replace /* code will be added here later */ with the following code snippet.



You can now call the getdata method in the Cordova project. Add the following to the constructor method in Couchbase/www/index.html.




To test your changes, you must re-install the Cordova plugin. Modify Couchbase.swift, index.html and Couchbase.js (JavaScript Interface) to add new functionalities.

