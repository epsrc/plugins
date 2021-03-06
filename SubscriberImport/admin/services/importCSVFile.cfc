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
    <cfargument name="ML_Users" type="string" />

    <!--- No.of seconds:  14400 = 4hrs --->
    <cfsetting requestTimeout = "14400">

    <cfset var templist = "" />
    <cfset var fieldlist = "" />
    <cfset var data = "">
    <cfset var I = 0/>

    <!--- local.MLID should be a current one and therefore already exist (remember here we are updating existing Mailing Lists --->
    <cfset var local.MLID = arguments.mailingListManager.read('', arguments.siteid, listBean.getName()).getAllValues().MLID />
    <cfif not Len(local.MLID)>
        <cfset local.MLID = arguments.listBean.getMLID() />
    </cfif>
<!---
    <cfdump var="#local.MLID#">
    <cfdump var="#arguments.ML_Users#">
    <cfabort>
 --->
    <cfset groupName = listBean.getName() />

    <cffile ACTION="upload"
            destination="#arguments.configBean.getTempDir()#"
            filefield="listfile"
            nameconflict="makeunique" >
    <!--- cffile.serverfile is 'set' by cffile action above --->
    <cffile file="#arguments.configBean.getTempDir()##cffile.serverFile#"
            variable="tempList"
            action="read" >

    <cfif (arguments.ML_Users eq "ML")>

        <cfset tempList = "#reReplace(tempList,"(#chr(13)##chr(10)#|#chr(10)#|#chr(13)#)|\n|(\r\n)","|","all")#">
        <cfif arguments.direction eq 'replace'>
            <cfset arguments.mailingListManager.deleteMembers(local.MLID, arguments.siteid) />
        </cfif>
        <cfloop list="#templist#" index="I" delimiters="|">
            <!--- This checked that a valid email was first field
            <cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 >  --->
            <cfset I = arguments.utility.listFix(I,chr(44),"_null_")>
            <cfset ID = listgetat(I,1,chr(44))/>
            <cfset var email = listgetat(I,2,chr(44))/>
            <cfset var active = listgetat(I,3,chr(44))/>

            <cfif ((arguments.direction eq 'add') OR (arguments.direction eq 'replace')) and
                   (UCASE(listFirst(I,chr(44)) neq "ID") AND UCASE(listFirst(I,chr(9)) neq "EMAIL")) and
                   (active eq "1") >

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

                <!--- CREATE THE MAILING LIST MEMBERSHIP FROM FILE DATA --->
                <cfset arguments.mailinglistManager.createMember(data) />
                <cfset sleep(100) />
            </cfif>
        </cfloop>
    </cfif>

    <cfif (arguments.ML_Users eq "Users")>
        <!--- SITE USERS (MEMBERS of a Member GROUP) if he/she doesn't yet have an email listed in site users --->
        <cfscript>

            var groups = arguments.userManager.getUserGroups(arguments.siteid,1);
            var getGroupID = new Query(sql = "SELECT UserID FROM groups WHERE groupname LIKE '" & groupName & "'",
                                            dbtype = "query",
                                            groups = groups
                                            );
            var groupID = getGroupID.execute().getResult().userID;

            <!--- TODO: test if this group exists yet? If not, create it --->
            var q = arguments.mailinglistManager.getListMembers(local.MLID, arguments.siteid);
            for (
                    intRow = 1 ;
                    intRow LTE q.RecordCount;
                    intRow = (intRow + 1)
                 )
                {
                var subscribe = 'Subscriber';
                var userBean = arguments.userManager.getBean('user');
                userBean.setUserManager(arguments.userManager);
                userBean.setSiteID(arguments.siteid);

                var username=q['email'][intRow];
                userBean.loadBy(userName=username);

                if (arguments.direction eq 'remove'){
                    // Get rid of this User forever...
                    var userID = userBean.getValue('userID');
                    userBean.removeGroupID(groupID);
                    userBean.delete();
                    arguments.userManager.deleteUserFromGroup(userID,  groupID);
                    arguments.userManager.delete(userID);
                    // Also remove from Mailing List
                    removeMLM = new Query();
                    removeMLM.setSQL("delete from tmailinglistmembers where email='#username#' and
                                      mlid='#local.MLID#' and
                                      siteid='#arguments.SiteID#'
                                     ");
                    removeMLM.execute();
                }else{
                    // without userName you cannot save the user, we  have to use the email provided
                    userBean.setValue('userName', username);
                    userBean.setValue('email', username);
                    // without these you cannot find the user!
                    userBean.setValue('groupID', groupID);
                    userBean.setValue('groupName', groupName);
                    // These are required on BE admin form, so best to set to some value (seems password can be left out though)
                    if (not Len(userBean.getValue('FName'))){
                        userBean.setValue('FName', 'Unknown');
                    }
                    if (not Len(userBean.getValue('LName'))){
                        userBean.setValue('LName', 'Unknown');
                    }
                    // these will vary according to preference and according to group the user is being created for
                    if (groupName eq 'Call Alert'){
                        if (userBean.getValue('subscribeCallAlert') eq 'Unsubscribe'){
                            if (q['isVerified'][intRow] eq 1){
                                subscribe='Subscriber';
                                //if (not Len(userBean.getValue('subscribeCallAlertFrequency'))){
                                    // default value - User can change this later via Edit Profile form
                                    frequency='Instant';
                                //}
                            }else{
                                subscribe='Unsubscribe';
                                frequency='';
                            }
                        }
                        // userBean.setValue('subscribeCallAlertFrequency', frequency);
                        userBean.setValue('subscribeCallAlert', subscribe);
                    }
                    // only now save the user
                    userBean.save();
                    userManager.update(userBean.getAllValues(), true);
                }
                sleep(100);
            }
        </cfscript>
    </cfif>
    <!--- IF WE ARE REMOVING --->
    <cfif  arguments.direction eq 'remove'>
        <cfquery>
        delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#" /> and
                    mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.MLID#" /> and
                    siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SiteID#" />
        </cfquery>
    </cfif>

    <!--- Site Users are Member's have that belong to a Member Group - this group must be the same name as the Mailing List
        // (or else it's almost impossible to find them again) --->
    <cfset local.userIterator = arguments.userManager.readByGroupName(groupName,
                                                                      arguments.siteid).GETMEMBERSITERATOR() />

    <!--- Output/Result: THIS LISTS THE FIRST 100 <Mailing Group> USERS/MEMBERS in the Call List Members Group--->
    <cfsavecontent variable="html">
        <cfoutput>
            <cfif local.userIterator.hasNext()>
                <ul>
                    <cfset cnt = 0/>
                    <cfloop condition="local.userIterator.hasNext() and cnt lt 100">
                        <cfset user = local.userIterator.next() />
                        <li>
                            #HTMLEditFormat(user.getValue('lname'))#, #HTMLEditFormat(user.getValue('fname'))#, #HTMLEditFormat(user.getValue('email'))# <br />
                            #HTMLEditFormat(user.getValue('subscribeCallAlert'))#
                            <!--- <cfdump var="#user.getAllValues()#" /><cfabort /> --->
                        </li>
                        <cfset cnt++ />
                    </cfloop>
                </ul>
            <cfelse>
                <div class="alert alert-info alert-dismissable">
                    <strong>#groupName#!</strong> This Mailing List Group has no Users!
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
                       ,arguments.ML_Users
                      );

        if (Len(html)){
            return html;
        }else{
            return "Something went wrong again!";
        }
    }
</cfscript>

</cfcomponent>