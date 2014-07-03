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
        variables.ClassExtensionManager = arguments.configBean.getClassExtensionManager();
        variables.userDAO = super.getBean("userDAO");
        //var address=super.getBean("userDAO").readAddress(event.getValue("addressID"))>arguments.userDAO;

    <!--- In addition, these are available (via Mura/FW1 ?) in th e'rc'

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
        var jobs = getJobFunctionsArray();

        if (qry.recordCount eq 0){
            return "No AD Contacts Directory found";
        }else{
            var groupname = 'Contacts Directory';
            var groupID   = getMuraGroupID(groupname);
            var cnt = 0;
            for (contact in qry){
                //if ((contact.lastname eq "Bailey") and (contact.firstname eq "Catherine")){
                //if ((contact.lastname eq "Coates") and (contact.firstname eq "Catherine")){
                // get contact info in step with Mura
                UpdateMemberUser(contact,
                                 groupID,
                                 groupname,
                                 getJobFunctionsString(jobs, contact.PersonID));

                    // delay and count cos I do not trust ORM, Railo, Mura, MSSQL or even Cf to execute code reliably in this shite server environment...
                    sleep(100);
                //}
                cnt++;
            }
            return "Success - #cnt# updated";
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

    private void function UpdateMemberUser(required contact, string groupID, string groupname, string jobFunctions){

        // contact structure (from xml)
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
        // extended attributes
        userBean.setValue('subscribeCallAlert', 'Unsubscribe');
        // now save the user
        userBean.save();

        // 'Contacts Directory' 'address' attributes

        // ADDRESS BEAN
        // ============
        // ADDOBJECTS           Array
        // ADDRESS1             string
        // ADDRESS2             string
        // ADDRESSEMAIL         string
        // ADDRESSID            string  F1FE8D9D-28A3-43AF-A44A111197FFE289
        // ADDRESSNAME          string
        // ADDRESSNOTES         string
        // ADDRESSURL           string
        // CITY                 string
        // COUNTRY              string
        // ERRORS               Struct
        // EXTENDAUTOCOMPLETE   boolean true
        // EXTENDDATA           string
        // EXTENDDATATABLE      string  tclassextenddatauseractivity
        // EXTENDSETID          string
        // FAX                  string
        // FROMMURACACHE        boolean false
        // HOURS                string
        // INSTANCEID           string  7F7D021B-F3CA-49E0-9461CB5E3AC6EE08
        // ISNEW                number  0
        // ISPRIMARY            number  0
        // LATITUDE             number  0
        // LONGITUDE            number  0
        // PHONE                string
        // REMOVEOBJECTS        Array
        // SITEID               string  MuraDevSite
        // SOURCEITERATOR       string
        // STATE                string
        // SUBTYPE              string  Default
        // TYPE                 string  Address
        // USERID               string
        // ZIP                  string
        var addressBean = getBean("addressBean");
        var addressID = getContactDirectory(userBean.getAddresses())
        var newone = false;

        if (len(addressID)){
            addressBean = userBean.getAddressBeanById(addressID);
        }else{
            addressBean.setAddressID(createuuid());
            newone = true;
        }
        // the user 'address' attributes...
        addressBean.setSiteID(userBean.getSiteID());
        addressBean.setUserID(userBean.getUserID());

        addressBean.setValue('addressemail',contact.email);
        addressBean.setValue('phone',contact.phone);
        addressBean.setValue('addressname','Contacts Directory');

        if (not newone){
            addressBean.setValue('ADDRESS1', addressBean.getValue('ADDRESS1'));
            addressBean.setValue('ADDRESS2', addressBean.getValue('ADDRESS2'));
            addressBean.setValue('ADDRESSURL', addressBean.getValue('ADDRESSURL'));
            addressBean.setValue('CITY', addressBean.getValue('CITY'));
            addressBean.setValue('COUNTRY', addressBean.getValue('COUNTRY'));
            addressBean.setValue('FAX', addressBean.getValue('FAX'));
            addressBean.setValue('HOURS', addressBean.getValue('HOURS'));
            addressBean.setValue('STATE', addressBean.getValue('STATE'));
            addressBean.setValue('ZIP', addressBean.getValue('ZIP'));
        }
        addressBean.save();
        // extended attributes
        if (structIsEmpty(addressBean.getErrors())){

            //if (local.newone){
            //    variables.userDAO.createAddress(addressBean);
            //}else{
                variables.userDAO.updateAddress(addressBean);
            //}

            var id = addressBean.getAllValues().extendsetid;
            if (len(id)){

                // You have to save Extended Attributes this way....
                // what a pile of obscure undocumented piss it really is...
                // trying to figure out this crap is almost as much fun as shitting razor-blades...

                var data = StructNew();
                data.siteID = addressBean.getSiteID();
                data.addressID = addressBean.getAddressID();
                data.userID = userBean.getUserID();
                data.extendSetId = id;

                data.contactsDirTitle = contact.title;
                data.contactsDirWorkArea = contact.orgDescription;
                data.contactsDirJobTitle = contact.jobtitlename;
                data.contactsDirJobFunctions = arguments.jobfunctions;

                variables.ClassExtensionManager.saveExtendedData( addressBean.getAddressID(),
                                                                  data,
                                                                  'tclassextenddatauseractivity');
            }
        }
    }

    private any function getJobFunctionsArray(){

        var file = $.siteConfig('themeAssetPath') & "/display_objects/custom/contacts_data/jobfunctions.xml"
        if (fileExists(file)){

            fileObj = fileRead(file);
            var functions = XMLParse(fileObj);
            fileClose(fileOpen(file));

            var functionsArray = functions.Envelope.Body.PopulateJobFunctionsResponse.PopulateJobFunctionsResult.diffgram.documentElement.jobfunction;
        }
        return functionsArray;
    }

    private string function getJobFunctionsString(functionsArray, personID){

        var size = ArrayLen(functionsArray);
        var jobfunctionsString = '';

        for (i=1; i LTE size; i++){
            if (structKeyExists(functionsArray[i],"PersonID") and
                functionsArray[i].PersonID.XmlText eq personID and
                len(trim(functionsArray[i].Description.XmlText))){

                jobFunctionsString &=  functionsArray[i].Description.XmlText & ', ';
            }
        }
        if (len(jobFunctionsString)){
            jobFunctionsString = left(jobFunctionsString, len(jobFunctionsString)-2);
        }

        return jobfunctionsString;
    }

    private query function getContactsQuery(){

        var file1 = $.siteConfig('themeAssetPath') & "/display_objects/custom/contacts_data/employees.xml"

        <!--- check age and existence of employees.xml and retrieve if older than 24H or missing (e.g. post code deployment) --->
        if (fileExists(file1)){

            fileObj1 = fileRead(file1);
            var employeeXml = XMLParse(fileObj1);
            fileClose(fileOpen(file1));

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
    }

    private string function getContactDirectory(required query qAddresses){

        var qAddressID = new Query(sql = "SELECT addressID FROM addresses WHERE addressName LIKE 'Contacts Directory'",
                                   dbtype = "query",
                                   addresses = qAddresses
                                  );
        return qAddressID.execute().getResult().addressID;
    }

</cfscript>

</cfcomponent>