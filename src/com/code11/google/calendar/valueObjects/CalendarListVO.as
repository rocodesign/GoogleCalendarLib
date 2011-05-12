package com.code11.google.calendar.valueObjects
{
	import mx.collections.ArrayCollection;

	public class CalendarListVO
	{
		public function CalendarListVO()
		{
		}
		
		public var kind:String;
		public var etag:String;
		public var id:String;
		public var updated:String;
		public var author:AuthorVO;
		public var feedLink:String;
		public var selfLink:String;
		public var canPost:Boolean;
		
		[ArrayElementType('com.code11.google.calendar.valueObjects.CalendarVO')]
		public var items:ArrayCollection;
	}
}