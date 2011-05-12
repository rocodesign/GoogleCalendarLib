package com.code11.google.calendar.services {
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import mx.core.mx_internal;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.messaging.MessageAgent;
	import mx.messaging.MessageResponder;
	import mx.messaging.channels.DirectHTTPChannel;
	import mx.messaging.config.LoaderConfig;
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.messaging.messages.IMessage;
	import mx.netmon.NetworkMonitor;
	
	use namespace mx_internal;
	
	public class AuthDirectHTTPChannel extends DirectHTTPChannel {
		
		public function AuthDirectHTTPChannel(id:String=null, uri:String="") {
			super(id, uri);
		}
		
		
		override public function setCredentials(credentials:String, agent:MessageAgent=null, charset:String=null):void{
			this.credentials = credentials;
		}
		
		private var log:ILogger = Log.getLogger("AuthDirectHTTPChannel");
		override protected function internalSend(msgResp:MessageResponder):void {
			var httpMsg:HTTPRequestMessage = msgResp.message as HTTPRequestMessage;
			if(credentials && httpMsg)	{
				httpMsg.httpHeaders["Authorization"] = "GoogleLogin auth="+credentials;
				httpMsg.httpHeaders["GData-Version"] = 2;
			}
			super.internalSend(msgResp);
		} 
		
		override public function logout(agent:MessageAgent):void {
			credentials = null;
		}
		
		override mx_internal function createURLRequest(message:IMessage):URLRequest {
			var req:URLRequest = super.createURLRequest(message);
			var httpMsg:HTTPRequestMessage = HTTPRequestMessage(message);
			req.method = httpMsg.method;
			
			if (!req.data && req.method != HTTPRequestMessage.GET_METHOD) req.data = httpMsg.body;
			return req;
		}
		
	}
}