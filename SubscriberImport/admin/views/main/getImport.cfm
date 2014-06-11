<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfoutput>
<div class="main">
<div class="main-inner">
<div class="container">

<div class="row-fluid">
<div class="span12">
	<h1>Mailing List Subscribers</h1>
    <p>Add/Remove Subscribers (public site users that are Members of and Subscribe to the chosen mailing list)</p>
    <form name="importmaillist" id="importmaillist" method="post" action="#buildURL( 'main.doImport' )#" enctype="multipart/form-data">
<div class="tabbable tabs-left mura-ui">
<div class="tab-content">
<div id="tabBasic" class="tab-pane active">
<div class="fieldset">

        <div class="control-group">
            <label class="control-label">Mailing List</label>
            <div class="controls">
            <select name="mailingListName" onchange="">
                <option value="Call Alert" selected>Call Alert</option>
                <option value="Another List">Another List</option>
            </select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Subscriber maintenance</label>
            <div class="controls">
            <label for="da" class="radio inline">
                <input type="radio" name="direction" id="da" value="add" checked>Add to List (if don't exist)
            </label>
            <label for="dm" class="radio inline">
                <input type="radio" name="direction" id="dm" value="remove">Remove from List (if found)
            </label>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">MailingList or Users</label>
            <div class="controls">
            <label for="ml" class="radio inline">
                <input type="radio" name="ML_Users" id="ml" value="ML" checked>Mailing List Member update
            </label>
            <label for="us" class="radio inline">
                <input type="radio" name="ML_Users" id="us" value="Users" >Users update
            </label>
            <label for="us" class="radio inline">
                <input type="radio" name="ML_Users" id="us" value="ShowOnly">Show Users only
            </label>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">
            #application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#
            </label>
            <div class="controls">
                <input type="file" name="listfile" id="listfile" accept="text/plain" >
            </div>
        </div>

        <div class="form-actions">
            <input type="submit" value="Import" class="btn">
        </div>

</div>
</div>
</div>
</div>
    </form>
</div>
</div>

</div>
</div>
</div>
</cfoutput>
<!--- Client-side JS validation here --->
<script type="text/javascript">
    $("#importmaillist" ).submit(function(event){
        var eMail = document.getElementById("listfile").value;
        // validate required fields
        var errors = 0;
        if (eMail === "") {
            errors++;
        }
        if (errors > 0){
            alert('You must select a file!');
        }
        return errors === 0;
    });
</script>