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

            //WriteDump(rc.userFeed.getAllValues());
            //WriteDump(rc.listBean);
            //abort;

            // rc
            // arguments                 1 Empty:null
            // LISTBEAN                  2 Component (mura.mailinglist.mailinglistBean)
            // USERFEED                  3 Component (mura.user.userFeedBean)
            // ISFRONTENDREQUEST         4 boolean false
            // SITENAME                  5 string  Mura Dev Site
            // SITEBEAN                  6 Component (mura.settings.settingsBean)
            // direction                 7 string  add
            // $                         8 Component (mura.MuraScope)
            // SETTINGSMANAGER           9 Component (mura.settings.settingsManager)
            // mailingListName          10 string  Call Alert
            // ISADMINREQUEST           11 boolean true
            // CONFIGBEAN               12  Component (mura.configBean)
            // USERMANAGER              13 Component (mura.user.userManager)
            // fieldnames               14 string  listfile,direction,mailingListName
            // UTILITY                  15 Component (mura.utility)
            // listfile                 16 string  C:\MuraCMS\tomcat\webapps\ROOT\WEB-INF\railo\temp\tmp-27.upload
            // compactDisplay           17 string  false
            // SubscriberImportaction   18 string  admin:main.doimport
            // PC                       19  Component (mura.plugin.pluginConfig)
            // ACTION                   20 string  admin:main.doimport
            // siteid                   21 string MuraDevSite
            // PLUGINCONFIG             22 Component (mura.plugin.pluginConfig)

            // invoke IMPORT service here...
            variables.fw.service('importCSVFile.doImport', 'importServiceResult', rc);
        }else{
            rc.importServiceResult = 'Something went wrong when trying to do an import based on what you entered!';
        }
    }

}