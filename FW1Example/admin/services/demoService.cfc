component persistent="false" accessors="true" output="false" extends="mura.cfobject" {

	public any function init() {
		return this;
	}

	// as called by variables.fw.service('demoService.getCurrentDate') in main.cfc
	public any function getCurrentDate(string format) {
		// simple demo function, obviously you'll do more than this
		return dateFormat(now(),format);
	}
}