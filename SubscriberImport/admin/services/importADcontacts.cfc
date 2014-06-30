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

        WriteDump(variables);
        abort;

    }
</cfscript>

</cfcomponent>