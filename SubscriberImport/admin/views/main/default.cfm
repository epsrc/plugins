<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<h2>Home</h2>
	<p>
    Welcome to the Subscriber Import Plugin. This plugin allows you to import a CSV file to create or delete mailing list
    subscriptions. Subscriber's are added (or removed) from a named Mailing List and public Site Users with Membership
    to the Mailing List are automatically created.
    </p>
    <p>
    If their Subscription is currently 'active' they are by default given Call Alert Subscribe status with frequency set to
    Instant. Otherwise status is set to Unsubscribe. It is then up to the User to verify that they want to become active
    on the list by completing a subscription verification process.
    </p>
    <p>
    Due to Mura limitations we have to use the subscribers <strong>email address</strong> as the 'username'.
    </p>
</cfoutput>