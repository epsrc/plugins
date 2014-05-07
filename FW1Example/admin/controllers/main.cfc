/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {

	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		// rc.varName = 'whatever';
	}

    public any function sayHello(required rc){
        
        rc.message = 'Hello ';
        if(structKeyExists(rc,'name')){
            rc.message &= rc.name;
        }
    }
	// From default.cfm 'admin:main.callService'
    public any function callService(required rc){
        args            = {format = 'DDDD D MMMM YYYY'};
        // function return value (result) goes into named var which is placed in rc context  
        variables.fw.service('demoService.getCurrentDate', 'serviceCallResult', args);
    }

}