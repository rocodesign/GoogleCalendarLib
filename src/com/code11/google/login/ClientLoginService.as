package com.code11.google.login
{
	import com.code11.util.LogUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	public class ClientLoginService  extends EventDispatcher {
		
		private var _applicationId:String;
		private var _userName:String;
		private var _userPassword:String;
		private var _authenticationToken:String = null;
		
		
		private var httpService:HTTPService;
		public function ClientLoginService() {
			httpService = new HTTPService();
		}
		
		public function authenticateUser(userName:String,userPassword:String,service:String,applicationId:String = "sample-application"):AsyncToken {	
			_applicationId = applicationId;
			_userName = userName != null?userName:"";
			_userPassword = userPassword != null?userPassword:"";
			_authenticationToken = null;
			if(userName == null || _userPassword == null) {
				//log.fatal("Needs an username and password to login");
			}
			httpService.url = "https://www.google.com/accounts/ClientLogin";
			httpService.method = "POST";
			httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			
			var params:Object = {source:applicationId,service:service,Email:userName,Passwd:userPassword};
			
			var token:AsyncToken = httpService.send(params);
			
			return token;
		}
		
		
		
	}
}