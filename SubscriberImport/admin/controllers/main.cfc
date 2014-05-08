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

            // put all the form values and 'mura shit' in args for the import service cfc
            args = {listName = rc.mailingListName,
                    fileDelim = rc.configBean.getFileDelim(),
                    listBean = rc.listBean,
                    configBean = rc.configBean,
                    utilityCfc = rc.utility};

            // invoke IMPORT service here...
            variables.fw.service('importCSVFile.doImport', 'importServiceResult', args);
        }else{
            rc.importServiceResult = 'Something went wrong when trying to do an import based on what you entered!';
        }
    }

}