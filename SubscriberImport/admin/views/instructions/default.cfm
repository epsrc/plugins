<cfsilent>
<!---
This file is part of the Subscriber Import plugin

Copyright 2010-2014 Bill Tudor, WRTSS Ltd.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfoutput>
    <h2>General Instructions</h2>
    <p>The file you import is based on EPSRC standard extract from the current 'Call Alert' Sharepoint mailing list.</p>
    <p>It is expected that the first line of the file is the following: <strong>"ID,Email,Activated"</strong></p>
    <p>This is used to identify that the file is of the correct format.</p>
    <p>Following lines must be in the following format of three COMMA SEPARATED fields, each line of data separated by a CR or CR+LF:</p>
    <ul>
        <li>ID - a number (expected but not used)</li>
        <li>EMAIL - any valid AND UNIQUE email address - this will become the Subscriber/Member's username</li>
        <li>ACTIVE - valid values are 0 or 1
            <ul>
                <li>1 - Subscriber is already an active Subscriber to the mailing list</li>
                <li>0 - not active, the Subscriber will have to activate the subscription before they will get any emails</li>
            </ul>
        </li>
    </ul>
    <p><strong>No other format will work!</strong></p>
    <p><strong>No guarantee can be given that this plugin will work in any predictable way if the wrong format of file is used.</strong></p>
</cfoutput>