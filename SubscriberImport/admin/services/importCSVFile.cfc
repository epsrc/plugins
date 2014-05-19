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
            <!--- CREATE THE MAILING LIST MEMBERSHIP --->
            <cfset arguments.mailinglistManager.createMember(data) />

        <cfelseif  arguments.direction eq 'remove'>
            <cfquery>
            delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#" /> and
                        mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.MLID()#" /> and
                        siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SiteID#" />
            </cfquery>
        </cfif>
    </cfloop>

    <!--- CREATE THE SITE USER (Member of a Member Group) if he/she doesn't yet have an email listed in site users --->
    <cfscript>
        var groupName = listBean.getName();
        var groups = arguments.userManager.getUserGroups(arguments.siteid,1);
        var getGroupID = new Query(sql = "SELECT UserID FROM groups WHERE groupname LIKE '" & groupName & "'",
                                        dbtype = "query",
                                        groups = groups
                                        );
        var groupID = getGroupID.execute().getResult();
        <!--- TODO: test is this group exists yet? If not, create it --->

        var userBean = arguments.userManager.getBean('user');
        userBean.setUserManager(arguments.userManager);

        var q = arguments.mailinglistManager.getListMembers(local.MLID, arguments.siteid);
        WriteDump(q.RecordCount);
        for (
                intRow = 1 ;
                intRow LTE q.RecordCount;
                intRow = (intRow + 1)
             )
            {
            //userBean.loadBy(email=q['email'][intRow]);
            WriteDump(q['email'][intRow]);
            //WriteDump(userBean.getAllValues());
            //if (not Len(userBean.getValue('userName'))){
                WriteDump('New User');
                // without userName you cannot save the user, so use the email provided
                userBean.setValue('userName', q['email'][intRow] );
                userBean.setSiteID(arguments.siteid);
                userBean.setValue('email', q['email'][intRow] );
                // without these you cannot find the user!
                userBean.setValue('groupID', groupID.userid);
                userBean.setValue('groupName', groupName);

                //userBean.setUsernameNoCache(q['email'][intRow]);
                // These are required on BE admin form, so best to set to some value (seems password can be left out though)
                userBean.setValue('FName', 'Unknown');
                userBean.setValue('LName', 'Unknown');
	            // these will vary according to preference and according to group the user is being created for
	            if (groupName eq 'Call Alert'){
	                if (not Len(userBean.getValue('subscribeCallAlert'))){
	                    userBean.setValue('subscribeCallAlert', 'Unsubscribe');
	                    userBean.setValue('subscribeCallAlertFrequency','');
	                }
	            }
	            // now save the user
	            userBean.save();
            //}
            };

        abort;
        // Site Member's have to belong to a Member Group - we will make this the same as the Mailing List
        // (or else it's almost impossible to find them again)
        var local.userIterator = arguments.userManager.readByGroupName(groupName,
                                                                       arguments.siteid).GETMEMBERSITERATOR()
    </cfscript>

    <!--- Output: List all <Mailing Group> users --->
    <cfsavecontent variable="html">
        <cfoutput>
            <cfif local.userIterator.hasNext()>
                <ul>
                    <cfloop condition="local.userIterator.hasNext()">
                        <cfset user = local.userIterator.next() />
                        <li>
                            #HTMLEditFormat(user.getValue('lname'))#, #HTMLEditFormat(user.getValue('fname'))#, #HTMLEditFormat(user.getValue('email'))# <br />
                            #HTMLEditFormat(user.getValue('subscribeCallAlert'))#, #HTMLEditFormat(user.getValue('subscribeCallAlertFrequency'))#
                            <!--- <cfdump var="#user.getAllValues()#" /> --->
                        </li>
                    </cfloop>
                </ul>
            <cfelse>
                <div class="alert alert-info alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">ABORT</button>
                    <strong>Yo!</strong>No users belong to this Mailing Group and cannot be imported!
                </div>
            </cfif>
        </cfoutput>
    </cfsavecontent>

    <!--- remove the temporary 'work' file --->
    <cffile ACTION="delete"
            file="#arguments.configBean.getTempDir()##cffile.serverfile#" >

    <cfreturn html/>
</cffunction>

<cfscript>
    public string function doImport(args arguments) {
        // So here we can write a CSV import routine ?
        var data = structNew();

        // don't ask me why but Mura only copes with the args var being called arguments!
        // even though it would make more sense to call it rc because that's the thing passed!
        // Confusion + Obscura - what a winning combination!

        data.name = arguments.mailingListName;
        data.isPublic = "1";
        data.isPurge = "0";
        data.siteid = arguments.siteid;
        data.description = "Call Alert list (maintained via plugin)";

        // 'set' the listBean to the one we are changing here - needs to be existing if already exists, otherwise a new one
        arguments.listBean.set(data);

        // DO NOT EVEN ASK - FOR 'arguments' here, read 'rc', i.e. what WAS already avaiable as rc. in controller and main .cfc's
        // here has to be bastardised as 'arguments' !!!
        html = upload( arguments.listBean
                       ,arguments.configBean
                       ,arguments.direction
                       ,arguments.utility
                       ,arguments.userManager
                       ,arguments.mailinglistManager
                       ,arguments.siteid
                      );

        if (Len(html)){
            return html;
        }else{
            return "Something went wrong again!";
        }
    }
</cfscript>

</cfcomponent>