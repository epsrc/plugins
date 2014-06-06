/*

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="controller" {

    // *********************************  PAGES  *******************************************

    public any function default(required rc) {
        rc.default = 'whatever';
    }

    public any function doImport(required rc){
        if (isDefined("rc.mailingListName")){

            // rc
            // arguments                 1 Empty:null
            // LISTBEAN                  2 Component (mura.mailinglist.mailinglistBean)
            // USERFEED                  3 Component (mura.user.userFeedBean)
            // ISFRONTENDREQUEST         4 boolean false
            // SITENAME                  5 string  Mura Dev Site
            // SITEBEAN                  6 Component (mura.settings.settingsBean)
            // direction                 7 string  add
            // $                         8 Component (mura.MuraScope)
            // SETTINGSMANAGER           9 Component (mura.settings.settingsManager)
            // mailingListName          10 string  Call Alert
            // ISADMINREQUEST           11 boolean true
            // CONFIGBEAN               12  Component (mura.configBean)
            // USERMANAGER              13 Component (mura.user.userManager)
            // fieldnames               14 string  listfile,direction,mailingListName
            // UTILITY                  15 Component (mura.utility)
            // listfile                 16 string  C:\MuraCMS\tomcat\webapps\ROOT\WEB-INF\railo\temp\tmp-27.upload
            // compactDisplay           17 string  false
            // SubscriberImportaction   18 string  admin:main.doimport
            // PC                       19  Component (mura.plugin.pluginConfig)
            // ACTION                   20 string  admin:main.doimport
            // siteid                   21 string MuraDevSite
            // PLUGINCONFIG             22 Component (mura.plugin.pluginConfig)

            // invoke IMPORT service here...
            variables.fw.service('importCSVFile.doImport', 'importServiceResult', rc);
        }else{
            rc.importServiceResult = 'If you want to Import again, run through the menu option agian.';
        }
    }

    public any function runMailshot(required rc) {

        var callAlertInstantText = '<p>Here is a summary of the call</p>';
        var mailer = application.serviceFactory.getBean('mailer');
        var manager = application.serviceFactory.getBean('emailManager');
        var datasource="#manager.getconfigBean().getReadOnlyDatasource()#";
        var username="#manager.getconfigBean().getReadOnlyDbUsername()#";
        var password="#manager.getconfigBean().getReadOnlyDbPassword()#";
        var image = "";
        var issueDate = "";
        var callOpenDate = "";
        var callClosingDate = "";
        var callClosingTime = "";
        var relatedTheme = "";
        var callType = "";
        var subject = "";

        <!--- With this Group Member GUID, should be able to get a list of all the active Members who are
        subscribed to the Instant Call Alert list --->
        var siteID = $.event('siteid');
        var userManager = $.getBean('userManager');
        var groups = userManager.getPublicGroups(siteID);
        var qGroupID = new Query(sql = "SELECT userID,Email FROM groups WHERE groupname LIKE 'Call Alert'",
                                 dbtype = "query",
                                 groups = groups
                                );

        // irritating that Mura uses userID when it means groupID...!

        var groupID = qGroupID.execute().getResult().userID;
        var groupEmail = qGroupID.execute().getResult().Email;
        var qMembers = $.getBean('userManager').readGroupMemberships(groupID);
        <!---
            <cfdump var="#groups#">
            <cfdump var="#qMembers#">
        --->
        var cnt = 0;

        // TODO: need to get the feed (RSS content collection called 'Call Alert') as this will have the
        // fields and the iterator...

        var flds = ListToArray(feed.fields);

        while ((feed.iterator.hasNext()) and (cnt LT 1)) {
            <!--- each Call in the feed --->
            var item = feed.iterator.next();

            <!--- These are all the fields; we may need to 'loop' these to perform substitution within in
                  template text placeholders e.g. {{title}} --->
            subject = "Instant Call Alert - ";
            for (i=1; i LTE ArrayLen(flds); i++){
                    switch(flds[i]) {
                        case "Title":
                            subject &= item.getValue(i);
                            break;
                        case "Image":
                            image = item.getValue(i);
                            break;
                        case "issueDate":
                            issueDate = item.getValue(i);
                        case "callOpenDate":
                            callOpenDate = item.getValue(i);
                            break;
                        case "callClosingDate":
                            callClosingDate = item.getValue(i);
                            break;
                        case "callClosingTime":
                            callClosingTime = item.getValue(i);
                            break;
                        case "relatedTheme":
                            relatedTheme = item.getValue(i);
                            break;
                        case "callType":
                            callType = item.getValue(i);
                            break;
                        case "Summary":
                            callAlertInstantText &= item.getValue(i);
                            break;
                }
            }
            <!--- TODO: could use an email template to personalise this call alert email and use more fields --->

            <!--- loop for all active subscribed members --->
            for (intRow = 1; intRow LTE qMembers.RecordCount; intRow++){

                if (qMembers["inActive"][intRow] eq 0 and qMembers["subscribe"][intRow] eq 1){

                        // needed a user bean to get the call alert subscribe status
                        var userBean = userManager.getBean('user');
                        userBean.setSiteID(siteID);
                        userBean.loadBy(userName=qMembers["email"][intRow]);
                        <!--- the field 'qMembers.subscribe' really means 'use Mura email broadcaster'
                              the class extension here is what thw user themselves sets in their preferences
                              So we could also use the frequency preference here as well --->
                        if ( userBean.getValue('subscribeCallAlert') eq 'Subscribe' ){
                            <!--- NB: THIS CAN POTENTIALLY SEND 100's of emails !!! --->
                            mailer.sendTextAndHTML( callAlertInstantText
                                                   ,callAlertInstantText
                                                   ,userBean.getValue('email')
                                                   ,groupEmail
                                                   ,subject
                                                   ,siteID
                                                  );
                        }
                }

            } // for each member

        } // for each call in the feed

    } // runMailshot
}