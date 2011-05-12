package com.code11.google.calendar.valueObjects
{
	public class CalendarVO
	{
		public function CalendarVO()
		{
			
		}
		
		public var kind:String;
		public var etag:String;
		public var id:String;
		public var created:String;
		public var updated:String;
		
		public var title:String;
		public var eventFeedLink:String;
		public var accessControlListLink:String;
		public var selfLink:String;
		public var canEdit:Boolean;
		public var author:AuthorVO;
		public var accessLevel:String;
		public var color:String;
		public var hidden:Boolean;
		public var selected:Boolean;
		public var timeZone:String;
		public var location:String;
		public var timesCleaned:String;
	}
}