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

        // Mura scope IS visible because of this
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
		rc.rsSites = rc.pc.getAssignedSites();
		rc.listSites = ValueList(rc.rsSites.siteid);
        rc.userManager = rc.$.getBean('userManager');
        rc.mailingListManager = rc.$.getBean('mailinglistManager');

        // NOT BOLLOCKS - HERE IS THE WAY (that works) TO GET TO THE LOT...
        // Life gets hard when you have to fight authoritative decalartaions of the wway things are
        rc.configBean = rc.$.getBean('configBean');
        rc.listBean = rc.$.getServiceFactory().getBean('mailinglist');
        rc.utility = rc.$.getServiceFactory().getBean('utility');
        rc.emailUtility = $.getServiceFactory().getBean('emailUtility');
        rc.userFeed = rc.$.getServiceFactory().getBean('userFeed');
        rc.userFeed.setSiteID('MuraDevSite');
        rc.mailer = rc.$.getServiceFactory().getBean('mailer');
        //variables.pluginConfig.setSetting("pluginPath","#rc.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/");

        // BT,03.07.14: this can only work for sites with EPSRC theme set so check that component is available
        if (len(FindNoCase($.event('siteid'), rc.listSites)) and
            fileExists("#$.siteConfig('themeAssetPath')#\helpers\utils.cfc")){
            rc.helpersUtils = CreateObject("component", "#$.siteConfig('themeAssetPath')#\helpers\utils");
        }else{
            location(url='/admin/?muraAction=cSettings.list##tabPlugins', addtoken=false);
        }

        // UserFeed is all Memebers (as defined, Site, System, Private, Public whatever)
        // nb: we think private == Site (2), public == System (1)

		if ( rc.isFrontEndRequest ) {
			location(url='#rc.$.globalConfig('context')#/', addtoken=false);
		}
	}
}