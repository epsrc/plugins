<!--- Do Not Edit --->
<cfif not isDefined('this.name')>
<cfoutput>Access Restricted.</cfoutput>
<cfabort>
</cfif>
<cfset pluginDir=getDirectoryFromPath(getCurrentTemplatePath())/>
<cfset this.customtagpaths = listAppend(this.customtagpaths, pluginDir & "/profile/lib" )>
<cfset arrayAppend(this.ormsettings.cfclocation, pluginDir & "/profile/lib")>
