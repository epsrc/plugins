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
	<p>Welcome to the Subscriber Import Plugin. With this you can use an EPSRC csv file to create and delete Call Alert
    subscriptions. Subscriber's are added to the Mailing List named 'Call Alert' and public Site Users with Membership
    to this Mailing List are automatically created. If their Subscription is cuurrently active they are by default given
    Call Alert Subscribe status with frequency set to Instant.</p>
    <p>Due to Mura limitations we have to use the subscribers email address as the 'username'.
    </p>
</cfoutput>