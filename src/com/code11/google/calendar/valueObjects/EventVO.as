package com.code11.google.calendar.valueObjects
{
	import mx.collections.ArrayCollection;

	public class EventVO
	{
		
		public var kind:String;
		public var etag:String;
		public var id:String;
		public var selfLink:String;
		public var alternateLink:String;
		public var canEdit:Boolean;
		public var title:String;
		public var created:String;
		public var updated:String;
		public var details:String;
		public var status:String;
		
		public var creator:AuthorVO;
		
		public var anyoneCanAddSelf:Boolean;
		public var guestsCanInviteOthers:Boolean;
		public var guestsCanModify:Boolean;
		public var guestsCanSeeGuests:Boolean;
		public var sequence:int;
		public var transparency:String;
		public var visibility:String;
		public var location:String;
		
		[ArrayElementType('com.code11.google.calendar.valueObjects.AtendeeVO')]
		public var attendees:ArrayCollection;
		[ArrayElementType('com.code11.google.calendar.valueObjects.TimeRangeVO')]
		public var when:ArrayCollection;
	}
}