package com.code11.google.login
{
	import com.adobe.googlecalendar.events.GoogleCalendarAuthenticatorEvent;
	import com.adobe.googlecalendar.model.GoogleCalendarModelLocator;
	import com.code11.util.LogUtil;
	
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	
	public class ClientLogin  extends EventDispatcher {
		
		private var _applicationId:String;
		private var _userName:String;
		private var _userPassword:String;
		private var _authenticationToken:String = null;
		
		private var log:ILogger = LogUtil.getLogger(this);
		
		private var httpService:HTTPService;
		public function ClientLogin() {
			httpService = new HTTPService();
		}
		
		public function authenticateUser(userName:String,userPassword:String,service:String,applicationId:String = "sample-application"):void {	
			_applicationId = applicationId;
			_userName = userName != null?userName:"";
			_userPassword = userPassword != null?userPassword:"";
			_authenticationToken = null;
			if(userName == null || _userPassword == null) {
				log.fatal("Needs an username and password to login");
			}
			httpService.url = "https://www.google.com/accounts/ClientLogin";
			httpService.method = "POST";
			var params:Object = {source:applicationId,service:service,Email:userName,Passwd:userPassword};
			
			var token:AsyncToken = httpService.send(params);
			token.addResponder(new Responder(handleAuthenticationResult, handleAuthenticationFault));
			
			log.debug("authenticateUser " + userName);		
		}
		
		private function handleAuthenticationResult(event:ResultEvent):void
		{
			log.debug("Authenticated " + _userName);
			
			if(event.result != null && event.result is String) {
				_authenticationToken = event.result.split("Auth=")[1];
			} else {
				return;
			}
			
			var authenticatedUser:AuthenticatedUser = new AuthenticatedUser();
			authenticatedUser.email = _userName;
			authenticatedUser.password = _userPassword;
			authenticatedUser.token = _authenticationToken;
			authenticatedUser.loggedInTime = new Date();
			
			var authEvent:GoogleCalendarAuthenticatorEvent;
			
			//authentication successful
			if(_authenticationToken != null)
			{
				log.debug("Authentication successful");
				authEvent = new GoogleCalendarAuthenticatorEvent(
					GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE);
				
				authenticatedUser.authenticated = true;
			}
			else
			{
				log.debug("Authentication token missing");
				authEvent = new GoogleCalendarAuthenticatorEvent(
					GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT);
				authEvent.errorMessage = "Authentication token missing";
				
				authenticatedUser.authenticated = false;
			}	
			
			authEvent.authenticatedUser = authenticatedUser;
			dispatchEvent(authEvent);
				
		} 
		
		private function handleAuthenticationFault(event:FaultEvent):void
		{
			log.debug("Login Failed");
			
			var authenticatedUser:AuthenticatedUser = new AuthenticatedUser();
			authenticatedUser.email = _userName;
			authenticatedUser.password = _userPassword;
			authenticatedUser.token = _authenticationToken;
			authenticatedUser.loggedInTime = new Date();			
			authenticatedUser.authenticated = false;
			
		}
		
	}
}