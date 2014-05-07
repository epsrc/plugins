<cfoutput>
    <h1>Sample Form</h1>
    <h2>#rc.message#</h2>
    <form action="#buildURL('admin:main.sayHello')#" method="post">
        <label for="name">What's your name?</label>
        <input type="input" name="name">
        <input type="submit" value="Say Hello">
    </form>
</cfoutput>