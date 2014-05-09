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

    <cfset tempList = "#reReplace(tempList,"#chr(10)#|#chr(13)#|(#chr(13)##chr(10)#)|\n|(\r\n)","|","all")#">
    <cfif arguments.direction eq 'replace'>
        <cfset application.mailingListManager.deleteMembers(arguments.listBean.getMLID(),arguments.listBean.getSiteID()) />
    </cfif>

    <cfloop list="#templist#" index="I"  delimiters="|">
    <cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{1,255}\.[^@%*<>' ]{2,5}", trim(listFirst(i,chr(9)))) neq 0 >

        <cfif arguments.direction eq 'add' or arguments.direction eq 'replace'>
        <cfset I = arguments.utilityCfc.listFix(I,chr(9),"_null_")>
        <cftry>
            <cfset data=structNew()>
            <cfset data.mlid=arguments.listBean.getMLID() />
            <cfset data.siteid=arguments.listBean.getsiteid() />
            <cfset data.isVerified=1 />
            <cfset data.email=listFirst(I,chr(9)) />
            <cfset data.fname=listgetat(I,2,chr(9)) />
            <cfif data.fname eq "_null_">
                <cfset data.fname="" />
            </cfif>
            <cfset data.lname=listgetat(I,3,chr(9)) />
            <cfif data.lname eq "_null_">
                <cfset data.lname="" />
            </cfif>
            <cfset data.company=listgetat(I,4,chr(9)) />
            <cfif data.company eq "_null_">
                <cfset data.company="" />
            </cfif>
        <cfcatch></cfcatch>
        </cftry>

        <cfset application.mailinglistManager.createMember(data) />

        <cfelseif  arguments.direction eq 'remove'>
            <cfquery>
            delete from tmailinglistmembers where email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(i,chr(9))#" /> and mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#" />
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
        var templist ="";
        var fieldlist ="";
        var data="";
        var I=0;

        // need to 'set' the listBean - with name: search for -> cfset listBean.set(arguments.data)

        //writeDump(arguments);
        //abort;
        // how to call upload() ?
        upload('replace', arguments.listBean, arguments.configBean, arguments.utility);

        return "CSV file succesfully imported!";
    }
</cfscript>

</cfcomponent>