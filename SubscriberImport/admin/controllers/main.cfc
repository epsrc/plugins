/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {

	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		rc.default = 'whatever';
	}

    public any function doImport(required rc){
        if (isDefined("rc.mailingListName")){
            rc.stuff = rc.mailingListName;
        }else{
            //rc.stuff = 'Undefined';
        }
    }

    // From default.cfm 'admin:main.callService'
    public any function callService(required rc){
        args = {format = 'DDDD D MMMM YYYY'};
        // function return value (result) goes into named var which is placed in rc context
        variables.fw.service('demoService.getCurrentDate', 'serviceCallResult', args);
    }
<!---
    public any function saveStuff(required rc){
        rc.stuff = rc.sometext;
    }

    public any function doSomethingLikeCallWebService(required rc){
        rc.resultOfPost = "Let's pretend I called a webservice!"
        // attempt to redirect back to the posting Form - CAREFUL - THIS FUCKS UP EVERYTHING !!!
        // variables.fw.redirect( "main.saveStuff");
    }

    public any function getImport(required rc){
        rc.defaultMemberList = 'Call Alert';
    } --->
}