<cfoutput>
<p>
    #title#</br>
    <cfif len(issueDate) >
        Issue Date: #dateformat(issueDate,'dd Mmm yyyy')#</br>
    </cfif>
    <cfif len(callOpenDate)>
        Call Open Date: #dateformat(callOpenDate,'dd Mmm yyyy')#</br>
    </cfif>
    <cfif len(callClosingDate)>
        Call Closing Date: #dateformat(callClosingDate,'dd Mmm yyyy')#
        <cfif len(callClosingTime)>
           #timeformat(callClosingTime,'HH:mm')#</br>
        <cfelse>
            </br>
        </cfif>
    </cfif>
    <cfif len(relatedTheme)>
        Related Themes: #relatedTheme#</br>
    </cfif>
    <cfif len(calltype)>
        Call Type: #callType#</br>
    </cfif>
    <cfif len(summary)>
        <p>#summary#</p></hr>
    </cfif>
</p>
</br>
</cfoutput>