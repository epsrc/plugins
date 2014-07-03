<cfinclude template="../includes/fw1config.cfm" />
<cfoutput>
<plugin>
    <name>Subscriber Import</name>
    <package>#variables.framework.package#</package>
    <directoryFormat>packageOnly</directoryFormat>
    <provider>Bill Tudor</provider>
    <providerURL>http://epsrc.ac.uk</providerURL>
    <loadPriority>5</loadPriority>
    <version>#variables.framework.packageVersion#</version>
    <category>Application</category>
    <ormcfclocation />
    <customtagpaths />
    <mappings />
    <settings />
    <eventHandlers>
         <eventHandler event="onApplicationLoad" component="includes.eventHandler" persist="false" />
    </eventHandlers>
    <displayobjects location="global">
         <displayobject name="Simple Display Object (unused)" displayobjectfile="includes/display_objects/simple.cfm" />
    </displayobjects>

    <extensions>
        <extension type="Site">
            <attributeset name="Subscriber">
                <attribute
                    name="showSubscriberLogin"
                    label="Allow Subscriber Login or Register"
                    hint="Allow Subscribers to Login or Register via Front End"
                    type="selectBox"
                    defaultValue="No"
                    required="true"
                    optionList="Yes^No"
                    optionLabelList="Yes^No"
                />
            </attributeset>
        </extension>
        <extension type="Address">
            <attributeset name="Contacts Directory (AD)">
                <attribute
                    name="contactsDirTitle"
                    label="Preferred Title"
                    hint="Title to prefix the Contact name with"
                    type="textBox"
                />
                <attribute
                    name="contactsDirWorkArea"
                    label="Work area/Organisation Description"
                    hint="General Contact work are or description"
                    type="textBox"
                />
                <attribute
                    name="contactsDirJobTitle"
                    label="Job Title"
                    hint="The Contact Job Title"
                    type="textBox"
                />
                <attribute
                    name="contactsDirJobFunctions"
                    label="Job Functions"
                    hint="The Contact Job Functions"
                    type="textArea"
                />
            </attributeset>
        </extension>
    </extensions>
</plugin>
</cfoutput>