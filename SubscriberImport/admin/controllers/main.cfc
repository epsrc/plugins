/*

This file is part of MuraFW1

Copyright 2010-2014 Bill Tudor, WRTSS Ltd.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {

    public any function default(required rc) {
        rc.default = 'whatever';
    }
    // *********************************  FORM or MENU ACTIONS  TIED-IN VIA FW1 ***************************************

    // Import CSV File
    public any function doImport(required rc){
        if (isDefined("rc.mailingListName")){
            // invoke IMPORT service here...
            variables.fw.service('importCSVFile.doInit', 'RESULT', rc);
            variables.fw.service('importCSVFile.doImport', 'importServiceResult', rc);
        }else{
            rc.importServiceResult = 'If you want to Import again, run via the menu option again.';
        }
    }

    // Run a Mailshot for Call Alert Members
    public any function runMailshot(required rc) {

        // invoke MAILSHOT service by pressing Go (submit) button on form...
        variables.fw.service('runMailshot.doInit', 'RESULT', rc);
        variables.fw.service('runMailshot.doMailshot', 'RESULT', form);

    }

    // Manually load up employees and jobfunctions xml from Sharepoint 'Contacts Directory'
    public any function loadADContacts(required rc){
        // invoke services here...
        variables.fw.service('importADContacts.doInit', 'RESULT', rc);
        variables.fw.service('importADContacts.doImport', 'RESULT');
    }
}