package com.code11.google.login
{

	public class AuthenticatedUser 
	{
		public var token:String;
		public var email:String;
		public var password:String;
		public var authenticated:Boolean;
		public var loggedInTime:Date;
		
		
		public function AuthenticatedUser()
		{
			super();
		}
	}
}