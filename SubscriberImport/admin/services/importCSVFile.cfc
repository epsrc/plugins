<cfcomponent extends="mura.cfobject" output="false" persistent="false" accessors="true" >

<cffunction name="init" access="public" returntype="any" output="false">
<!---
    <cfset var fileDelim="/"/>
    <cfset fileDelim = rc.configBean.getFileDelim() />
 --->
    <cfreturn this />
</cffunction>

<cffunction name="upload" access="public" returntype="void" output="false">
    <cfargument name="direction" type="string" />
    <cfargument name="listBean" type="any" />
    <cfargument name="configBean" type="any" />
    <cfargument name="utilityCfc" type="any" />

    <cfset var templist ="" />
    <cfset var fieldlist ="" />
    <cfset var data="">
    <cfset var I=0/>

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
        <cfset application.mailingListManager.deleteMembers(arguments.listBean.getMLID(),arguments.listBean.getSiteID()) />
    </cfif>

    <cfloop list="#templist#" index="I"  delimiters="|">

    <!--- I think this looked for email as first field
    <cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 >  --->

    <cfif arguments.direction eq 'add' or arguments.direction eq 'replace'>

        <cfset I = arguments.utilityCfc.listFix(I,chr(44),"_null_")>

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

        <cfset application.mailinglistManager.createMember(data) />
        <!--- and also create a site Member/User if he/she doesn't yet have an email listed in site members (users) --->

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

</cffunction>

<cfscript>
    public any function doImport(args arguments) {
        // So here we can write a CSV import routine ?
        var data = structNew();

        data.name = "Call Alert";
        data.isPublic = "1";
        data.isPurge = "0";
        data.siteid = arguments.$.getSite().getSiteID();
        data.description = "Call Alert list (maintained via plugin)"

        // need to 'set' the listBean - with name: search for -> cfset listBean.set(arguments.data)
        arguments.listBean.set(data)

//WriteDump(arguments.listBean.getsiteid());
//WriteDump(arguments.listBean.getMLID());
//abort;

        upload('replace', arguments.listBean, arguments.configBean, arguments.utility);

        return "CSV file succesfully imported!";
    }
</cfscript>

</cfcomponent>