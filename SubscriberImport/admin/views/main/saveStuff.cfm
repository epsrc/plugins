<cfoutput>
    <h2>Call Webservice</h2>
    <cfif isDefined("rc.resultOfPost")><p>#rc.resultOfPost#</p></cfif>
    <form action="#buildURL( 'main.doSomethingLikeCallWebService' )#" method="post">
        <input type="text" name="sometext">
        <input type="submit">
    </form>
</cfoutput>