/*

This file was part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

    NB: All ADMIN controllers should EXTEND this file.

*/
component persistent="false" accessors="true" output="false" extends="mura.cfobject" {

	property name='$';
	property name='fw';

	public any function init (required any fw) {
		setFW(arguments.fw);
	}

	public any function before(required struct rc) {

		if ( StructKeyExists(rc, '$') ) {
			var $ = rc.$;
			set$(rc.$);
		}
		// easy access to site attributes
		rc.settingsManager = rc.$.getBean('settingsManager');
		rc.siteBean = rc.settingsManager.getSite(rc.$.siteConfig('siteid'));
		rc.siteName = rc.siteBean.getSite();
        rc.siteId = rc.siteBean.getSiteId();
		// rc.rsAllSites = rc.settingsManager.getList();
		// rc.rsSites = rc.pc.getAssignedSites();
		// rc.listSites = ValueList(rc.rsSites.siteid);
        rc.userManager = rc.$.getBean('userManager');
        rc.mailingListManager = rc.$.getBean('mailinglistManager');

        // NOT BOLLOCKS - HERE IS A WAY (that works) TO GET TO THE LOT...
        rc.configBean = rc.$.getBean('configBean');
        //variables.pluginConfig.setSetting("pluginPath","#rc.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/");
        rc.listBean = rc.$.getServiceFactory().getBean('mailinglist');
        rc.utility = rc.$.getServiceFactory().getBean('utility');
        rc.userFeed = rc.$.getServiceFactory().getBean('userFeed');
        rc.userFeed.setSiteID('MuraDevSite');
        rc.userFeed.setGroupID('Call Alert', false);

        //WriteDump(rc.userFeed);
        //abort;

		if ( rc.isFrontEndRequest ) {
			location(url='#rc.$.globalConfig('context')#/', addtoken=false);
		}
	}
}