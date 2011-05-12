package com.code11.google.calendar.valueObjects
{
	import mx.collections.ArrayCollection;

	public class EventRequest
	{
		public function EventRequest(title:String = "No Title",details:String = "",transparency:String = "opaque",status:String = "confirmed",location:String = "Bucharest",timeRange:TimeRangeVO = null,recurrence:String = "") {
			this.title = title;
			this.details = details;
			this.transparency = transparency;
			this.status = status;
			this.location = location;
			if (timeRange) this.when = new ArrayCollection([timeRange]);
			this.recurrence = recurrence;
		}
		
		public var title:String;
		public var details:String;
		public var transparency:String;
		public var status:String;
		public var location:String;
		
		[ArrayElementType('com.code11.google.calendar.valueObjects.TimeRangeVO')]
		public var when:ArrayCollection;
		
		public var recurrence:String;
	}
}