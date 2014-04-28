/**
* 
* This file is part of MyFirstPlugin
*
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
function init(data) {

	initConfigurator(data,{
		url: '../plugins/MyFirstPlugin/extensions/configurators/jwplaylist/configurator.cfm'
		, pars: ''
		, title: 'MyFirstPlugin'
		, init: function(){}
		, destroy: function(){}
		, validate: function(){
			return true;
		}
	});

	return true;

};