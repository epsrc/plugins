<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
    <h2>Do Import</h2>
    <p>This form posts to itself, calling a service to do the import</p>
    <cfif isDefined("rc.stuff")><p>#rc.stuff#</p></cfif>
    <form action="#buildURL( 'main.doImport' )#" method="post">
        <input type="text" name="sometext">
        <input type="submit">
    </form>
    <cfdump var="#$#">
</cfoutput>