<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<h2>Home</h2>
	<p>Hello <cfif isDefined("rc.stuff")>#rc.stuff#</cfif></p>
    <form action="#buildURL( 'main.saveStuff' )#" method="post">
        <input type="text" name="sometext">
        <input type="submit">
    </form>
    <cfdump var="#$#">
</cfoutput>