<cfcomponent extends="mura.cfobject" output="false" persistent="false" accessors="true" >

<cfscript>
    public string function doInit(args arguments) {
    <!--- kind of the 'request scope'

        arguments null              1  nb: (sic) I know,I know !!!
        USERMANAGER                 2  Component (mura.user.userManager)
        PC                          3  Component (mura.plugin.pluginConfig)
        compactDisplay              4  string false
        ISADMINREQUEST              5  boolean true
        MAILINGLISTMANAGER          6  Component (mura.mailinglist.mailinglistManager)
        SITENAME                    7  string MuraDevSite
        EMAILUTILITY                8  Component (mura.email.emailUtility)
        siteid                      9  string MuraDevSite
        SubscriberImportaction      10 string  admin:main.loadadcontacts
        UTILITY                     11 Component (mura.utility)
        HELPERSUTILS                12 Component (MuraDevSite.includes.themes.EPSRC.helpers.utils)
        SITEBEAN                    13 Component (mura.settings.settingsBean)
        PLUGINCONFIG                14 Component (mura.plugin.pluginConfig)
        SETTINGSMANAGER             15 Component (mura.settings.settingsManager)
        $                           16 Component (mura.MuraScope)
        MAILER                      17 Component (mura.mailer)
        CONFIGBEAN                  18 Component (mura.configBean)
        ACTION                      19 string  admin:main.loadadcontacts
        ISFRONTENDREQUEST           20 boolean false
        USERFEED                    21 Component (mura.user.userFeedBean)
        LISTBEAN                    22 Component (mura.mailinglist.mailinglistBean)

        Assign any of these you need to a component 'variable'
     --->

        variables.$ = arguments.$;
        variables.utility = arguments.utility;
        variables.emailUtility = arguments.emailUtility;
        variables.helpersUtils = arguments.helpersUtils;
        variables.USERMANAGER = arguments.USERMANAGER;
        variables.siteID = arguments.siteID;

    <!--- In addition, these are available (via Mura/FW1 ?)

        COMMITTRACEPOINT    Public Function commitTracePoint    source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        DELETEMETHOD        Public Function deleteMethod        source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        DOIMPORT            Public Function doImport            source:C:\MuraCMS\tomcat\webapps\ROOT\plugins\SubscriberImport\admin\services\importADcontacts.cfc
        DOINIT              Public Function doInit              source:C:\MuraCMS\tomcat\webapps\ROOT\plugins\SubscriberImport\admin\services\importADcontacts.cfc
        GETASJSON           Public Function getAsJSON           source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETASSTRUCT         Public Function getAsStruct         source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETBEAN             Public Function getBean             source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETCONFIGBEAN       Public Function getConfigBean       source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETCURRENTUSER      Public Function getCurrentUser      source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETEVENTMANAGER     getEventManager
        GETPLUGIN           Public Function getPlugin           source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETPLUGINMANAGER    Public Function getPluginManager    source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETQUERYSERVICE     Public Function getQueryService     source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETSERVICEFACTORY   Public Function getServiceFactory   source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        GETVALUE            Public Function getValue            source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        INIT                Public Function init                source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        INITTRACEPOINT      Public Function initTracePoint      source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        INJECTMETHOD        Public Function injectMethod        source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        INVOKEMETHOD        Public Function invokeMethod        source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        REMOVEVALUE         Public Function removeValue         source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        SETVALUE            Public Function setValue            source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
        THIS                Component (SubscriberImport.admin.services.importADContacts)
        TRANSLATOR          string
        VALUEEXISTS         Public Function valueExists         source:C:\MuraCMS\tomcat\webapps\ROOT\requirements\mura\cfobject.cfc
    --->
    }

    public string function doImport(){

        var qry = getContactsQuery();

        if (qry.recordCount eq 0){
            return "No AD Contacts Directory found";
        }else{
            var groupname = 'Contacts Directory Members (AD)';
            var groupID   = getMuraGroupID(groupname);
            var cnt = 1;
            for (contact in qry){
                // get contact info in step with Mura
                UpdateMemberUser(contact, groupID, groupname);

                sleep(100);
                // delay and count cos I do not trust ORM, Railo, Mura, MSSQL or even Cf to execute code reliably...
                if (cnt eq 20){
                    return "Only doing #cnt#";
                }
                cnt++;
            }
            return "Success";
        }
    }

    private string function getMuraGroupID(required string groupname){
        var groups = variables.userManager.getUserGroups(variables.siteid,1);
        var qGroupID = new Query(sql = "SELECT UserID,Email FROM groups WHERE groupname LIKE '" & groupName & "'",
                                        dbtype = "query",
                                        groups = groups
                                  );
        return qGroupID.execute().getResult().userID;
    }

    private void function UpdateMemberUser(required contact, string groupID, string groupname){
        // directorate      string
        // Email            string  Tina.Thompson@epsrc.ac.uk
        // FirstName        string  Tina
        // JobTitleName     string  Management Accountant
        // Lastname         string  Thompson
        // OrgDescription   string  Finance
        // PersonID         string  8653
        // Phone            string  (01793) (44) 4277
        // Title            string  Miss

        var userBean = variables.userManager.getBean('user');
        userBean.setUserManager(variables.userManager);
        userBean.setSiteID(variables.siteid);
        var username = contact.email;
        userBean.loadBy(userName = username);
<!---
        WriteDump(userbean.getAllValues());
        WriteDump(contact);
        abort;
 --->
        userBean.setValue('userName', username);
        userBean.setValue('email', username);
        // without these you cannot find the user!
        userBean.setValue('groupID', groupID);
        userBean.setValue('groupName', arguments.groupname);
        userBean.setValue('FName', contact.firstname);
        userBean.setValue('LName', contact.lastname);

        // and the rest...
        userBean.setValue('remoteID', contact.personID);
        userBean.setValue('contactsDirectoryPhone', contact.phone);
        // Extended attributes
        userBean.setValue('subscribeCallAlert', 'Unsubscribe');
        userBean.setValue('contactsDirectoryWorkArea', contact.orgDescription);
        userBean.setValue('contactsDirectoryTitle', contact.title);
        userBean.setValue('contactsDirectoryJobTitle', contact.jobtitlename);

        // only now save the user
        userBean.save();
        variables.userManager.update(userBean.getAllValues(), true);
    }

    private query function getContactsQuery(){

        var file1 = $.siteConfig('themeAssetPath') & "/display_objects/custom/contacts_data/employees.xml"
        var file2 = $.siteConfig('themeAssetPath') & "/display_objects/custom/contacts_data/jobfunctions.xml"

        <!--- check age and existence of employees.xml and retrieve if older than 24H or missing (e.g. post code deployment) --->
        if (fileExists(file1) and
            fileExists(file2)){


            fileObj1 = fileRead(file1);
            var employeeXml = XMLParse(fileObj1);
            fileObj2 = fileRead(file2);
            var jobXml = XMLParse(fileObj2);
            fileClose(fileOpen(file1));
            fileClose(fileOpen(file2));

            var empArray = employeeXml.Envelope.Body.PopulateEmployeesResponse.
                                                     PopulateEmployeesResult.diffgram.employees.employee;
            var size = ArrayLen(empArray);

            // NB: QueryNew() = CF10
            var contacts = QueryNew("PersonID, Title, FirstName, Lastname, Email, JobTitleName, Phone, OrgDescription, directorate");
            QueryAddrow(contacts, size);
            for (i=1; i LTE size; i++){

                QuerySetCell(contacts, "PersonID", structKeyExists(empArray[i],"PersonID") ? empArray[i].PersonID.XmlText:'', i);
                QuerySetCell(contacts, "Title", structKeyExists(empArray[i],"Title") ? empArray[i].Title.XmlText:'', i);
                QuerySetCell(contacts, "Firstname", structKeyExists(empArray[i],"Firstname") ? empArray[i].Firstname.XmlText:'', i);
                QuerySetCell(contacts, "LastName", structKeyExists(empArray[i], "lastName") ? empArray[i].Lastname.XmlText:'', i);
                QuerySetCell(contacts, "Email", structKeyExists(empArray[i], "email") ? empArray[i].email.XmlText:'', i);
                QuerySetCell(contacts, "jobTitleName", structKeyExists(empArray[i], "jobTitleName") ? empArray[i].jobTitleName.XmlText:'', i);
                QuerySetCell(contacts, "Phone", structKeyExists(empArray[i], "Phone") ? empArray[i].Phone.XmlText:'', i);
                QuerySetCell(contacts, "orgDescription", structKeyExists(empArray[i],"orgDescription") ? empArray[i].orgDescription.XmlText:'', i);
                QuerySetCell(contacts, "directorate", structKeyExists(empArray[i],"directorate") ? empArray[i].directorate.XmlText:'', i);
            }

            return contacts;
        }else{
            var contacts = QueryNew("PersonID");
            return contacts;
        }

<!---
        <cfloop index="i" from = "1" to = "#size#" step="1">
            <cfset QuerySetCell(contacts, "PersonID", structKeyExists(empArray[i],"PersonID") ? empArray[#i#].PersonID.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "Title", structKeyExists(empArray[i],"Title") ? empArray[#i#].Title.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "Firstname", structKeyExists(empArray[i],"Firstname") ? empArray[i].Firstname.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "LastName", structKeyExists(empArray[i], "lastName") ? empArray[i].Lastname.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "Email", structKeyExists(empArray[i], "email") ? empArray[i].email.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "jobTitleName", structKeyExists(empArray[i], "jobTitleName") ? empArray[i].jobTitleName.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "Phone", structKeyExists(empArray[i], "Phone") ? empArray[i].Phone.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "orgDescription", structKeyExists(empArray[i],"orgDescription") ? empArray[i].orgDescription.XmlText:'', #i#)>
            <cfset QuerySetCell(contacts, "directorate", structKeyExists(empArray[i],"directorate") ? empArray[i].directorate.XmlText:'', #i#)>
        </cfloop>

        <cfquery dbtype="query" name="filteredContacts" result="result">
            select * from contacts
            <cfif searching>
             where
                 <!--- Searching as an OR on EACH term --->
                 <cfset var row = 0>
                 <cfloop list="#contactSearchList#" index="term">
                     <cfset row += 1>
                     firstname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%">
                     OR
                     lastname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%">
                     OR
                     jobTitleName like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%">
                     OR
                     orgDescription like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%">
                     OR
                     directorate like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%">
                     <cfif not(row eq listLen(contactSearchList))>
                         OR
                     </cfif>
                 </cfloop>
            <cfelseif $.event().valueExists('contactProfileID')>
                where personID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#$.event().getValue('contactProfileID')#">
            </cfif>
            order by lastname asc
        </cfquery>
        <cfreturn filteredContacts>
    <cfelse>
        <cfset var contacts = QueryNew("PersonID") >
        <cfquery dbtype="query" name="empty" result="result">
            select * from contacts WHERE PersonID = "StuffBV"
        </cfquery>
        <cfreturn empty>
    </cfif>
 --->
    }

</cfscript>

</cfcomponent>