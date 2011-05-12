package com.code11.util {
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	final public class LogUtil {
		
		public static function getLogger(c:*):ILogger {
			var className:String = getQualifiedClassName(c).replace("::", ".");
			return Log.getLogger(className);
		}
	}
}