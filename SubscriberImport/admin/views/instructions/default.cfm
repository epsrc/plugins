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
    <p>From Main/Subscriber Import Menu option:</p>
    <p>
    <ul>
    <li>Choose Mailing List. you are updating (only Call Alert exists so far).</li>
    <li>Select a Radio button (this decide whether you UPDATE the chosen list or DELETE subscribers using data in the file chosen.
    </li>
    <li>Select a file that MUST EXIST on the server.</li>
    <li>When you are satisfied you have chosen what you want press the Import button - this action is irreversible!</li>
    </ul>
    </p>
    <p>THIS PLUGIN IS NOT RESPONSIBLE FOR ENSURING THE FILE EXISTS OR THAT IT
    IS IN THE CORRECT FORMAT! When it is finished you should be presented with a list of all the Mailing List members/users that are in the chosen list after your Import.
    </p><p>The file you import is based on EPSRC standard extract from the current 'Call Alert' Sharepoint mailing list.
    It is expected that the first line of the file is the following: <strong>"ID,Email,Activated"</strong>. This is used to identify that the file is of the correct format.</p>
    <p>Data rows in the file must be in the following format of three COMMA SEPARATED fields, each line of data separated by a CR or CR+LF:</p>
    <ul>
        <li>ID - a number (expected but not used)</li>
        <li>EMAIL - any valid AND UNIQUE email address - this will become the Subscriber/Member's username</li>
        <li>ACTIVE - valid values are 0 or 1
            <ul>
                <li>1 - active - Subscriber is already an active Subscriber and will be created as such in Mura</li>
                <li>0 - not active, Subscriber will have to activate his/her subscription via verification of email address</li>
            </ul>
        </li>
    </ul>
    <p><strong>No other format will work!</strong></p>
    <p><strong>No guarantee can be given that this plugin will work in any predictable way if the wrong format of file is used.</strong></p>
</cfoutput>