<cfoutput>
<html><head><title>#subject#</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head><body text="##000000" link="##000000" vlink="##000000" alink="##000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
Hello <cfif len(#firstname#) or len(#lastname#)>#firstname# #lastname#<cfelse>#username#</cfif>
<p>This is EPSRC's email alert of the latest calls for proposals.</p>
</cfoutput>