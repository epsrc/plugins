<cfcomponent extends="mura.cfobject" output="false" persistent="false" accessors="true" >
<cfscript>
    public string function doInit(args arguments) {
<!---
        arguments               1           Empty:null
        USERMANAGER             2           Component (mura.user.userManager)
        PC                      3           Component (mura.plugin.pluginConfig)
        compactDisplay          4           string  false
        feedname                5           string  Call Alert
        ISADMINREQUEST          6           boolean true
        MAILINGLISTMANAGER      7           Component (mura.mailinglist.mailinglistManager)
        SITENAME                8           string  Mura Dev Site
        EMAILUTILITY            9           Component (mura.email.emailUtility)
        siteid                  10          string  MuraDevSite
        SubscriberImportaction  11          string  admin:main.runmailshot
        UTILITY                 12          Component (mura.utility)
        HELPERSUTILS            13          Component (MuraDevSite.includes.themes.EPSRC.helpers.utils)
        SITEBEAN                14          Component (mura.settings.settingsBean)
        PLUGINCONFIG            15          Component (mura.plugin.pluginConfig)
        SETTINGSMANAGER         16          Component (mura.settings.settingsManager)
        $                       17          Component (mura.MuraScope)
        mailshottype            18          string  Instant Call Alert
        MAILER                  19          Component (mura.mailer)
        batchlimit              20          string  100
        fieldnames              21          string  feedname,mailshottype,batchlimit
        CONFIGBEAN              22          Component (mura.configBean)
        ACTION                  23          string  admin:main.runmailshot
        ISFRONTENDREQUEST       24          boolean false
        USERFEED                25          Component (mura.user.userFeedBean)
        LISTBEAN                26          Component (mura.mailinglist.mailinglistBean)
 --->
        variables.$ = arguments.$;
        variables.batchlimit = Val(arguments.batchlimit);
        variables.configBean = arguments.configbean;
        variables.settingsManager = arguments.settingsManager;
        variables.siteID = arguments.siteid;
    }

    public any function doMailshot() {

        if (isDefined("variables.batchlimit")){

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
            var siteID = variables.$.event('siteid');
            var cnt = 0;

            // get the 'RSS' feed as this will have the 'display list' fields and iterator...
            var feed = variables.$.getBean('feed').loadBy(name=form.feedname);
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
                var userManager = variables.$.getBean('userManager');
                var groups = userManager.getPublicGroups(siteID);
                var qGroupID = new Query(sql = "SELECT userID,Email FROM groups WHERE groupname LIKE 'Call Alert'",
                                         dbtype = "query",
                                         groups = groups
                                        );
                // irritating that Mura uses userID when it means groupID...!
                var groupID = qGroupID.execute().getResult().userID;
                var groupEmail = qGroupID.execute().getResult().Email;
                var qMembers = variables.$.getBean('userManager').readGroupMemberships(groupID);

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
                            var unsubscribe = makeUnsubscribeLink(variables.configbean, subject, userBean.getValue('email'));
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
                    if (cnt gte variables.batchlimit){
                        sleep(variables.batchlimit*200);
                        cnt = 0;
                    }
                } // for each member
            }

        } // if called to Run by request

    } // runMailshot

    private string function makeUnsubscribeLink(required configbean,
                                                string emailID,
                                                string emailaddress){

        var scheme = variables.settingsManager.getSite(variables.siteID).getScheme()
        var domain = variables.$.getSite(variables.siteID).getDomain("production");

        var unsubscription = scheme & '://' &
                             domain &
                             configBean.getServerPort() &
                             configBean.getContext() &
                             '?doaction=unsubscription&emailid=' &
                             arguments.emailid &
                             '&email=' &
                             arguments.emailaddress &
                             '&nocache=1&mailingList=Call Alert';

        return unsubscription;
    }

    </cfscript>
</cfcomponent>