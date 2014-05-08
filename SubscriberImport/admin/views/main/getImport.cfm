<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<h2>Import Preferences</h2>
    <form method="post" action="#buildURL( 'main.doImport' )#" enctype="multipart/form-data">
        <input type="text" name="mailingListName" value="Call Alert">

        <div class="control-group">
            <label class="control-label">
            #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#
            </label>
            <div class="controls">
                <input type="file" name="listfile" accept="text/plain" >
            </div>
        </div>

        <input type="submit">
    </form>
</cfoutput>