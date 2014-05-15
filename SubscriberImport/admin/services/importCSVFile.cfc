<cfcomponent extends="mura.cfobject" output="false" persistent="false" accessors="true" >

<cffunction name="init" access="public" returntype="any" output="false">
<!---
    <cfset var fileDelim="/"/>
    <cfset fileDelim = rc.configBean.getFileDelim() />
 --->
    <cfreturn this />
</cffunction>

<cffunction name="upload" access="public" returntype="string" output="false">
    <cfargument name="listBean" type="any" />
    <cfargument name="configBean" type="any" />
    <cfargument name="direction" type="string" />
    <cfargument name="utility" type="any" />
    <cfargument name="userfeed" type="any" />
    <cfargument name="mailingListManager" type="any" />
    <cfargument name="siteid" type="string" />

<cfdump var="#arguments.mailingListManager.getList(arguments.siteid)#">
<cfdump var="#arguments.listBean.getMLID()#">
<cfabort>

    <cfset var templist ="" />
    <cfset var fieldlist ="" />
    <cfset var data="">
    <cfset var I=0/>

<!---
    <cfif StructKeyExists(arguments, "direction") and not Len(arguments.direction)>
        <cfset arguments.direction="replace" />
    </cfif>
 --->

    <cffile ACTION="upload"
            destination="#arguments.configBean.getTempDir()#"
            filefield="listfile"
            nameconflict="makeunique" >

    <!--- Need to establish where cffile.serverfile 'is' --->
    <cffile file="#arguments.configBean.getTempDir()##cffile.serverFile#"
            variable="tempList"
            action="read" >

    <cfset tempList = "#reReplace(tempList,"(#chr(13)##chr(10)#|#chr(10)#|#chr(13)#)|\n|(\r\n)","|","all")#">
    <cfif arguments.direction eq 'replace'>
        <cfset arguments.mailingListManager.deleteMembers(arguments.listBean.getMLID(), arguments.siteid) />
    </cfif>

    <cfloop list="#templist#" index="I"  delimiters="|">

    <!--- I think this looked for email as first field
    <cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 >  --->

    <cfif arguments.direction eq 'add' or arguments.direction eq 'replace'>

        <cfset I = arguments.utility.listFix(I,chr(44),"_null_")>

    <cfif listFirst(I,chr(44)) neq "ID">

        <cfset ID = listgetat(I,1,chr(44))/>
        <cfset var email = listgetat(I,2,chr(44))/>
        <cfset var active = listgetat(I,3,chr(44))/>

        <cftry>

            <cfset data=structNew()>
            <cfset data.mlid=arguments.listBean.getMLID() />
            <cfset data.siteid=arguments.listBean.getsiteid() />
            <cfset data.isVerified=1 />
            <cfset data.email=email />
            <cfset data.fname="" />
            <cfset data.lname="" />
            <cfset data.company="" />

        <cfcatch></cfcatch>
        </cftry>

        <cfset arguments.mailinglistManager.createMember(data) />
        <!--- and also create a site Member/User if he/she doesn't yet have an email listed in site members (users) --->

        <cfscript>
            // USER feed bean stuff
            // if user(s) belong to a different site, specify desired siteid
            // userFeed.setSiteID('someSiteID');

            // if you know the groupid, you can filter that
            // userFeed.setGroupID('someGroupID', false);

            // filter only users of a specific subType
            // userFeed.addParam(
            //  relationship='AND'
            //  , field='tusers.subtype'
            //  , condition='EQUALS'
            //  , criteria='Physician'
            //  , dataType='varchar'
            // );

            // the iterator!
            userIterator = arguments.userFeed.getIterator();
        </cfscript>
        <cfoutput>
            <cfif userIterator.hasNext()>
                <ul>
                    <cfloop condition="userIterator.hasNext()">
                        <cfset user = userIterator.next() />
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
                    <strong>Yo!</strong> No users match the filter criteria.
                </div>
            </cfif>
        </cfoutput>

        <cfelseif  arguments.direction eq 'remove'>
            <cfquery>
            delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#" /> and
                        mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#" /> and
                        siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#" />
            </cfquery>
        </cfif>
    </cfif>
    </cfloop>

    <cffile ACTION="delete"
            file="#arguments.configBean.getTempDir()##cffile.serverfile#" >

    <cfreturn 'OK'/>
</cffunction>

<cfscript>
    public string function doImport(args arguments) {
        // So here we can write a CSV import routine ?
        var data = structNew();

        // don't ask me why but fucking Mura can only cope with the args var being called arguments
        // even though it would make more sense to call it rc because that's tthe fucking thing it passes in!!!
        // Confusion + Obscura - what a winning combination!!!

        data.name = arguments.mailingListName;
        data.isPublic = "1";
        data.isPurge = "0";
        data.siteid = arguments.siteid;
        data.description = "Call Alert list (maintained via plugin)";

        // 'set' the listBean to the one we are changing here
        arguments.listBean.set(data);

        // DO NOT EVEN FUCKING ASK - FOR 'arguments' here, read 'rc' !!!
        if (upload( arguments.listBean
                   ,arguments.configBean
                   ,arguments.direction
                   ,arguments.utility
                   ,arguments.userfeed
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