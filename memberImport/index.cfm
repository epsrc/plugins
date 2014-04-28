<cfscript>
/**
*
* This file is part of MuraPlugin
*
* Copyright 2014 Bill Tudor (for and on behalf of EPSRC)
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<style type="text/css">
    #bodyWrap h3{padding-top:1em;}
    #bodyWrap ul{padding:0 0.75em;margin:0 0.75em;}
</style>
<cfsavecontent variable="body"><cfoutput>
<div id="bodyWrap">
    <h1>#HTMLEditFormat(pluginConfig.getName())#</h1>
    <p>This is a starter plugin to jumpstart your next Mura CMS plugin.</p>

    <!---
    <h3>pluginConfig</h3>
    <cfdump var="#pluginConfig#" label="pluginConfig" />
    --->

    <h3>Tested With</h3>
    <ul>
        <li>Mura CMS Core Version <strong>6.1+</strong></li>
        <li>Adobe ColdFusion <strong>10.0.9</strong></li>
        <li>Railo <strong>4.0.4</strong></li>
    </ul>

    <h3>Need help?</h3>
    <p>If you're running into an issue, please let EPSRC know at <a href="http://www.epsrc.ac.uk/about/contactus/Pages/feedback">Support</a><p>

    <p>Cheers!<br />
    <a href="http://wrtss.ltd.uk">Bill Tudor (for and on behalf of EPSRC)</a></p>

    <form class="fieldset-wrap" novalidate="novalidate" action="./?muraAction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">
        <div class="fieldset">
            <div class="control-group">
                <label class="control-label">Name</label>
                <div class="controls">
                    <input type="text" name="Name" value="" required="true" message="The List Name is required." class="span12">
                </div>
            </div>
<!---
        <div class="control-group">
        <label class="control-label">
            Type
        </label>
        <div class="controls">
            <label for="isPublicYes" class="radio inline">
            <input type="radio" value="1" id="isPublicYes" name="isPublic">
                Public
            </label>
            <label for="isPublicNo" class="radio inline">
            <input type="radio" value="0" id="isPublicNo" name="isPublic" checked="">
                Private
            </label>
            <input type="hidden" name="ispurge" value="0">
        </div>
        </div>
 --->
<!---
        <div class="control-group">
            <label class="control-label">
                Description
            </label>
            <div class="controls">
                <textarea id="description" name="description" rows="6" class="span12"></textarea>
                <input type="hidden" name="siteid" value="MuraDevSite">
            </div>
        </div>
 --->
            <div class="control-group">
                <label class="control-label">Upload List Maintenance File (Optional)
                    <div class="controls">
                        <label for="da" class="radio inline">
                            <input type="radio" name="direction" id="da" value="add" checked="">Add or replace email addresses of members
                        </label>
                        <label for="dm" class="radio inline">
                            <input type="radio" name="direction" id="dm" value="remove">Remove email adresses from members
                        </label>
                    </div>
                </label>
            </div>
            <div class="control-group">
                <label class="control-label">Upload Email Address File</label>
                <div class="controls">
                    <input type="file" name="listfile" accept="text/plain">
                </div>
            </div>
            <div class="form-actions">
                <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="Add">
                <input type="hidden" name="action" value="">
            </div>
        </div>
    </form>
</div>
</cfoutput></cfsavecontent>
<cfoutput>
    #$.getBean('pluginManager').renderAdminTemplate(
        body = body
        , pageTitle = ''
        , jsLib = 'jquery'
        , jsLibLoaded = false
    )#
</cfoutput>