<cfcomponent extends="mura.cfobject" output="false" persistent="false" accessors="true" >

<cffunction name="init" access="public" returntype="any" output="false">
<!---
    <cfset var fileDelim="/"/>
    <cfset fileDelim = rc.configBean.getFileDelim() />
 --->
    <cfreturn this />
</cffunction>

<cffunction name="upload" access="public" returntype="string" output="true">
    <cfargument name="listBean" type="any" />
    <cfargument name="configBean" type="any" />
    <cfargument name="direction" type="string" />
    <cfargument name="utility" type="any" />
    <cfargument name="userManager" type="any" />
    <cfargument name="mailingListManager" type="any" />
    <cfargument name="siteid" type="string" />

    <cfset var templist = "" />
    <cfset var fieldlist = "" />
    <cfset var data = "">
    <cfset var I = 0/>

    <!--- local.MLID should be a current one and therefore already exist (remember here we are updating existing Mailing Lists --->
    <cfset var local.MLID = arguments.mailingListManager.read('', arguments.siteid, listBean.getName()).getAllValues().MLID />
    <cfif not Len(local.MLID)>
        <cfset local.MLID = arguments.listBean.getMLID() />
    </cfif>

    <cffile ACTION="upload"
            destination="#arguments.configBean.getTempDir()#"
            filefield="listfile"
            nameconflict="makeunique" >
    <!--- cffile.serverfile is 'set' by cffile action above --->
    <cffile file="#arguments.configBean.getTempDir()##cffile.serverFile#"
            variable="tempList"
            action="read" >

    <cfset tempList = "#reReplace(tempList,"(#chr(13)##chr(10)#|#chr(10)#|#chr(13)#)|\n|(\r\n)","|","all")#">
    <cfif arguments.direction eq 'replace'>
        <cfset arguments.mailingListManager.deleteMembers(local.MLID, arguments.siteid) />
    </cfif>

    <cfloop list="#templist#" index="I" delimiters="|">
    <!--- I think this looked for email as first field
    <cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 >  --->
    <cfset I = arguments.utility.listFix(I,chr(44),"_null_")>
        <cfif ((arguments.direction eq 'add') OR (arguments.direction eq 'replace')) AND
               (UCASE(listFirst(I,chr(44)) neq "ID") AND UCASE(listFirst(I,chr(9)) neq "EMAIL")) >

            <cfset ID = listgetat(I,1,chr(44))/>
            <cfset var email = listgetat(I,2,chr(44))/>
            <cfset var active = listgetat(I,3,chr(44))/>

            <cftry>
                <cfset data = structNew()>
                <cfset data.mlid = local.MLID />
                <cfset data.siteid = arguments.siteid />
                <cfset data.isVerified = active />
                <cfset data.email = email />
                <cfset data.fname = '' />
                <cfset data.lname = '' />
                <cfset data.company = '' />
            <cfcatch></cfcatch>
            </cftry>

            <cfset arguments.mailinglistManager.createMember(data) />

            <!--- and also create a site Member/User if he/she doesn't yet have an email listed in site members (users) --->
	        <cfscript>
	            // the iterator!
                var local.userIterator = arguments.userManager.readByGroupName('Call Alert',arguments.siteid).GETMEMBERSITERATOR();
	        </cfscript>

	        <cfoutput>
	            <cfif local.userIterator.hasNext()>
	                <ul>
	                    <cfloop condition="local.userIterator.hasNext()">
	                        <cfset user = local.userIterator.next() />
	                        <li>
	                            #HTMLEditFormat(user.getValue('lname'))#, #HTMLEditFormat(user.getValue('fname'))#<br />
	                            #HTMLEditFormat(user.getValue('someExtendedAttributeNameGoesHere'))#
	                            <!--- <cfdump var="#user.getAllValues()#" /> --->
	                        </li>
	                    </cfloop>
	                </ul>
	            <cfelse>
	                <div class="alert alert-info alert-dismissable">
	                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	                    <strong>Yo!</strong>No users belong to this Mailing Group yet!
	                </div>
	            </cfif>
	        </cfoutput>

        <cfelseif  arguments.direction eq 'remove'>
            <cfquery>
            delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#" /> and
                        mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.MLID()#" /> and
                        siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SiteID#" />
            </cfquery>
        </cfif>
    </cfloop>

    <cffile ACTION="delete"
            file="#arguments.configBean.getTempDir()##cffile.serverfile#" >

    <cfreturn true/>
</cffunction>

<cfscript>
    public string function doImport(args arguments) {
        // So here we can write a CSV import routine ?
        var data = structNew();

        // don't ask me why but fucking Mura can only cope with the args var being called arguments
        // even though it would make more sense to call it rc because that's the fucking thing it passes in!!!
        // Confusion + Obscura - what a winning combination!!!

        data.name = arguments.mailingListName;
        data.isPublic = "1";
        data.isPurge = "0";
        data.siteid = arguments.siteid;
        data.description = "Call Alert list (maintained via plugin)";

        // 'set' the listBean to the one we are changing here - needs to be existing if already exists, otherwise a new one
        arguments.listBean.set(data);

        // DO NOT EVEN FUCKING ASK - FOR 'arguments' here, read 'rc', i.e. what WAS already avaiable as rc. in controller and main .cfc's
        // here has to be bastardised as 'arguments' - fuck's sake !!!
        if (upload( arguments.listBean
                   ,arguments.configBean
                   ,arguments.direction
                   ,arguments.utility
                   ,arguments.userManager
                   ,arguments.mailinglistManager
                   ,arguments.siteid
            )){
            return "CSV file succesfully imported!";
        }else{
            return "Something went wrong again!";
        }
    }
</cfscript>

</cfcomponent>