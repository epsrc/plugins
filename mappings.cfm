<!--- Do Not Edit --->
<cfif not isDefined('this.name')>
<cfoutput>Access Restricted.</cfoutput>
<cfabort>
</cfif>
<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>
<cfset this.mappings["/plugins"] = pluginDir>
<cfset this.mappings["/adminCSS"] = pluginDir & "/adminCSS">
<cfset this.mappings["/MuraPlayer"] = pluginDir & "/MuraPlayer">
<cfset this.mappings["/profile"] = pluginDir & "/profile">
<cfif not structKeyExists(this.mappings,"/test")><cfset this.mappings["/test"] = pluginDir & "/profile/lib"></cfif>
<cfset this.mappings["/SubscriberImport"] = pluginDir & "/SubscriberImport">
