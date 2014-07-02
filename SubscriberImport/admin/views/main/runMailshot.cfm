<cfoutput>
<div class="main">
<div class="main-inner">
<div class="container">

<div class="row-fluid">
<div class="span12">
    <h1>Run a Call Alert Mailshot</h1>
    <p>Works off the latest Call Alert feed (content collection) so make sure that this is set up correctly</p>
    <form name="runmailshot" id="runmailshot" method="post" action="" enctype="multipart/form-data">

<div class="tabbable tabs-left mura-ui">
<div class="tab-content">
<div id="tabBasic" class="tab-pane active">
<div class="fieldset">

        <div class="control-group">
            <label class="control-label">Mail Shot</label>
            <div class="controls">
            <select name="mailshottype" id="mailshottype" onchange="">
                <option value="Instant Call Alert" selected>Instant Call Alert</option>
                <option value="Weekly Call Alert" >Weekly Call Alert</option>
                <option value="Monthly Call Alert" >Monthly Call Alert</option>
            </select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">RSS Feed Name to use</label>
            <div class="controls">
                <label for="feedname" class="">
                    <input type="text" name="feedname" id="feedname" value="Call Alert">
                </label>
            </div>
        </div>

<!---
        <div class="control-group">
            <label class="control-label">Call Mura ID to use</label>
            <div class="controls">
                <label for="callid" class="">
                    <input type="text" name="callid" id="callid" value="Call Alert">
                </label>
            </div>
        </div>
 --->

        <div class="control-group">
            <label class="control-label">Limit batches to:</label>
            <div class="controls">
	            <label for="batchlimit" class="">
	                <input type="text" name="batchlimit" id="batchlimit" value="100">
	            </label>
            </div>
        </div>

        <div class="form-actions">
            <input type="submit" value="Go" class="btn">
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