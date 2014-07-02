<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
    <h2>Active Directory - Contacts Directory Import - Results...</h2>
    <cfif structKeyExists(rc,"importServiceResult") and isDefined("rc.importServiceResult")><p>#rc.importServiceResult#</p></cfif>
    <form action="#buildURL( 'main.doImport' )#" method="post" enctype="multipart/form-data">
<!---
        <input type="text" name="sometext">
        <input type="submit" value="OK">
 --->
    </form>
<!---
    <cfdump var="#$#">
 --->
</cfoutput>