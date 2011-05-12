 package com.code11.google.calendar.valueObjects
{
	public class CalendarRequestVO
	{
		public function CalendarRequestVO(title:String,details:String = "",timeZone:String = "UTC",hidden:Boolean = false,color:String = "#2952A3", location:String = "") {
			data = new CalendarItem();
			data.title = title;
			data.details = details;
			data.timeZone = timeZone;
			data.hidden = hidden;
			data.color = color;
			data.location = location;
		}
		
		public var data:CalendarItem;
	}
	

}

