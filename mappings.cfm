<!--- Do Not Edit --->
<cfif not isDefined('this.name')>
<cfoutput>Access Restricted.</cfoutput>
<cfabort>
</cfif>
<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>
<cfset this.mappings["/plugins"] = pluginDir>
<cfset this.mappings["/adminCSS"] = pluginDir & "/adminCSS">
<cfset this.mappings["/SubscriberImport"] = pluginDir & "/SubscriberImport">
