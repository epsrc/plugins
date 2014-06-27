/*

This file is part of MuraFW1

Copyright 2010-2014 Bill Tudor, WRTSS Ltd.
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
            // EMAILUTILITY                Component (mura.emailUtility)
            // listfile                 16 string  C:\MuraCMS\tomcat\webapps\ROOT\WEB-INF\railo\temp\tmp-27.upload
            // compactDisplay           17 string  false
            // SubscriberImportaction   18 string  admin:main.doimport
            // PC                       19  Component (mura.plugin.pluginConfig)
            // ACTION                   20 string  admin:main.doimport
            // siteid                   21 string MuraDevSite
            // PLUGINCONFIG             22 Component (mura.plugin.pluginConfig)
            // HelpersUtils

            // invoke IMPORT service here...
            variables.fw.service('importCSVFile.doInit', 'RESULT', rc);
            variables.fw.service('importCSVFile.doImport', 'importServiceResult', rc);
        }else{
            rc.importServiceResult = 'If you want to Import again, run through the menu option agian.';
        }
    }

    public any function runMailshot(required rc) {

        if (isDefined("rc.batchlimit")){

            var mailer = application.serviceFactory.getBean('mailer');
            var manager = application.serviceFactory.getBean('emailManager');
            var datasource = "#manager.getconfigBean().getReadOnlyDatasource()#";
            var username = "#manager.getconfigBean().getReadOnlyDbUsername()#";
            var password = "#manager.getconfigBean().getReadOnlyDbPassword()#";
            var title = "";
            var issueDate = "";
            var callOpenDate = "";
            var callClosingDate = "";
            var callClosingTime = "";
            var relatedTheme = "";
            var callType = "";
            var summary = "";
            <!--- With this Group Member GUID, should be able to get a list of all the active Members who are
                    subscribed to the Call Alert Member Group list --->
            var siteID = $.event('siteid');
            var cnt = 0;

            // get the 'RSS' feed as this will have the 'display list' fields and iterator...
            var feed = $.getBean('feed').loadBy(name=form.feedname);
            var flds = ListToArray(feed.getDisplayList());
            var iterator = feed.getIterator();
            <!--- each Call in the feed --->
            var callAlertBody = '';
            while (iterator.hasNext()) {
                var item = iterator.next();

                <!--- These are all the fields; we may need to 'loop' these to perform substitution within in
                      template text placeholders e.g. {{title}} --->
                for (i=1; i LTE ArrayLen(flds); i++){
                        switch(flds[i]) {
                            case "Title":
                                title = item.getValue(flds[i]);
                                break;
                            case "issueDate":
                                issueDate = item.getValue(flds[i]);
                            case "callOpenDate":
                                callOpenDate = item.getValue(flds[i]);
                                break;
                            case "callClosingDate":
                                callClosingDate = item.getValue(flds[i]);
                                break;
                            case "callClosingTime":
                                callClosingTime = item.getValue(flds[i]);
                                break;
                            case "relatedTheme":
                                relatedTheme = item.getValue(flds[i]);
                                break;
                            case "callType":
                                callType = item.getValue(flds[i]);
                                break;
                            case "Summary":
                                summary = item.getValue(flds[i]);
                                break;
                    }
                }
                <!--- TODO: use a Call Alert Summary email template to personalise the call alert email and
                      transpose the fields ? --->
                var emailBodyLayout = "..\..\common\layouts\emails\call_alert_summary.cfm";
                savecontent variable="bodyHTML"
                {
                    include '#emailBodyLayout#';
                }
                callAlertBody &= bodyHtml;
                cnt++;
            } // feed iterator loop

            <!--- Only if there are Calls --->
            if (cnt GT 0) {
                var subject = "Call Alert Summary";
                var callAlertText = '';

                // get Call Alert Member group stuff
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
                        if ( userBean.getValue('subscribeCallAlert') eq 'Subscriber' ){

                            // these vars are neeeded in the header email layout template
                            var firstname = iif(qMembers["Fname"][intRow] eq 'Unknown','','qMembers["Fname"][intRow]');
                            var lastname = iif(qMembers["Lname"][intRow] eq 'Unknown','','qMembers["Lname"][intRow]');
                            var username = qMembers["email"][intRow];
                            var emailHeaderLayout = "..\..\common\layouts\emails\call_alert_summary_header.cfm";
                            savecontent variable="headHTML"
                            {
                                include '#emailHeaderLayout#';
                            }

                            // these vars are neeeded in the footer email layout template
                            var unsubscribe = makeUnsubscribeLink(rc, subject, userBean.getValue('email'));
                            var emailFooterLayout = "..\..\common\layouts\emails\call_alert_summary_footer.cfm";
                            savecontent variable="footHTML"
                            {
                                include '#emailFooterLayout#';
                            }

                            var emailText = headHTML & callAlertBody & footHTML;

                            <!--- NB: THIS CAN POTENTIALLY SEND 100's of emails hence the counta and inbuilt delay --->
                            mailer.sendTextAndHTML( emailText
                                                   ,emailText
                                                   ,userBean.getValue('email')
                                                   ,groupEmail
                                                   ,subject
                                                   ,siteID
                                                  );
                            cnt += 1;
                        }
                    }
                    // add a delay to let the server-side resources (ie Mail server etc) 'catch up' with the lightning that is Mura...
                    if (cnt gte val(rc.batchlimit)){
                        sleep(rc.batchlimit*200);
                        cnt = 0;
                    }
                } // for each member
            }

        } // if called to Run by request

    } // runMailshot

    private string function makeUnsubscribeLink(required rc,
                                                string emailID,
                                                string emailaddress){

        var scheme = rc.settingsManager.getSite(rc.siteID).getScheme()
        var domain = rc.$.getSite(rc.siteID).getDomain("production");

        var unsubscription = scheme & '://' &
                             domain &
                             rc.configBean.getServerPort() &
                             rc.configBean.getContext() &
                             '?doaction=unsubscription&emailid=' &
                             arguments.emailid &
                             '&email=' &
                             arguments.emailaddress &
                             '&nocache=1&mailingList=Call Alert';
        return unsubscription;
    }
}