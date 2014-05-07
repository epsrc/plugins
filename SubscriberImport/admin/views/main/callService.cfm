<!--- All works via rc (in which is placed the service call result var) --->
<cfoutput>
<h2>This Service Says...</h2>
<p>The current date is: #rc.serviceCallResult#</p>
<p>The rc (request context) contains 2 components ($ and PC) and a few vars:</p>
<cfdump var="#rc#">
<!---
<p>Here is an error: #rc.crap#</p>
 --->
</cfoutput>