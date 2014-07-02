/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.pluginGenericEventHandler" {

	// framework variables
	include 'fw1config.cfm';

	// ========================== Mura CMS Specific Methods ==============================
	// Add any other Mura CMS Specific methods you need here.

	public void function onApplicationLoad(required struct $) {
		// trigger MuraFW1 setupApplication()
		getApplication().setupApplication();
		// register this file as a Mura eventHandler
		variables.pluginConfig.addEventHandler(this);

        // BOLLOCKS - ANOTHER PATHWAY MURA-OBSCURA (shit creek paddle etc)!
        //variables.configBean = $.getServiceFactory().getBean('configBean');
        //variables.pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/");
        //variables.listBean = getServiceFactory().getBean('mailinglist');
	}

	public void function onSiteRequestStart(required struct $) {
		arguments.$.setCustomMuraScopeKey(variables.framework.package, getApplication());
	}

	public any function onRenderStart(required struct $) {
		arguments.$.loadShadowboxJS();
	}

	// ========================== Helper Methods ==============================

	private any function getApplication() {
		if( !StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}

}

