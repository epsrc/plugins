component accessors=true extends='mura.plugin.pluginGenericEventHandler' output=false {
    property name='$' hint='mura scope';

    public any function onComponentEdit(required struct $) {
        variables.pluginConfig.addToHTMLHeadQueue('includes/custom-admin.cfm');
    }
    public any function onContentEdit(required struct $) {
        variables.pluginConfig.addToHTMLHeadQueue('includes/custom-admin.cfm');
    }
}