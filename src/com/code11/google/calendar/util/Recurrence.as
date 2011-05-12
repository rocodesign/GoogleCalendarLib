package com.code11.google.calendar.util
{
	import mx.collections.ArrayCollection;

	public class Recurrence
	{
		public static const YEARLY:String = "YEARLY";
		public static const MONTHLY:String = "MONTHLY";
		public static const WEEKLY:String = "WEEKLY";
		public static const DAILY:String = "DAILY";
		public static const HOURLY:String = "HOURLY";
		
		
		// ALL BYSOMETHING VALUES ARE COMMA DELIMITED VALUES
		/*bymolist   = monthnum / ( monthnum *("," monthnum) )
		monthnum   = 1DIGIT / 2DIGIT       ;1 to 12*/
		public static const BYMONTH:String = "BYMONTH";
		
		//1DIGIT / 2DIGIT       ;1 to 53
		//weekdaynum = [([plus] ordwk / minus ordwk)] weekday
		public static const BYWEEKNO:String = "BYWEEKNO";
		
		// bywdaylist = weekdaynum / ( weekdaynum *("," weekdaynum) )
		//within a MONTHLY rule +1MO (or simply 1MO) represents the first Monday within the month
		public static const BYDAY:String = "BYDAY";
		
		/*bymodaylist = monthdaynum / ( monthdaynum *("," monthdaynum) )
		monthdaynum = ([plus] ordmoday) / (minus ordmoday)
		ordmoday   = 1DIGIT / 2DIGIT       ;1 to 31*/
		public static const BYMONTHDAY:String = "BYMONTHDAY";
		
		/*byyrdaylist = yeardaynum / ( yeardaynum *("," yeardaynum) )
		yeardaynum = ([plus] ordyrday) / (minus ordyrday)
		ordyrday   = 1DIGIT / 2DIGIT / 3DIGIT      ;1 to 366*/
		public static const BYYEARDAY:String = "BYYEARDAY";
		public static const BYHOUR:String = "BYHOUR";
		
		//weekstart default "MO"
		//weekday    = "SU" / "MO" / "TU" / "WE" / "TH" / "FR" / "SA"
		public static const WKST:String = "WKST";
		
		
		public static const SUNDAY:String = "SU" 
		public static const MONDAY:String = "MO" 
		public static const TUESDAY:String = "TU" 
		public static const WEDNESDAY:String = "WE" 
		public static const THURSDAY:String = "TH" 
		public static const FRIDAY:String = "FR" 
		public static const SATURDAY:String = "SA"
		
		public static const UNTILL:String = "UNTILL";
		
		
		public static const DEFAULT_DAILY:String = "FREQ=DAILY";
		public static const DEFAULT_WEEKDAY:String = "FREQ=DAILY;BYDAY=Mo,Tu,We,Th,Fr";
		public static const DEFAULT_WEEKENDS:String = "FREQ=DAILY;BYDAY=Su,Sa";
		public static const DEFAULT_WEEKLY:String = "FREQ=WEEKLY";
		public static const DEFAULT_MONTHLY:String = "FREQ=MONTHLY";
		public static const DEFAULT_YEARLY:String = "FREQ=YEARLY";
		
		public function Recurrence() {
		}
		
		//"TZID=America/Los_Angeles:20060314T060000"; TZID=US-Eastern:19970105T083000
		//DTSTART:19970714T133000            ;Local time
		//DTSTART:19970714T173000Z           ;UTC time
		//DTSTART;TZID=US-Eastern:19970714T133000
		public var DTSTART:String = "";
		public var DTEND:String = "";
		//DURATION= "PT3600S"; "P" + / #"W" / # "H" / #M / #D / #D   EX: P15DT5H0M20S / P7W
		public var DURATION:String;
		
		//how often the recurrence rule repeats
		public var INTERVAL:int;
		
		public var WEEKDAYS:String;
		//FREQ examples
		
		/**
		 * RRULE:FREQ=DAILY;UNTIL=20060321T220000Z;UNTIL=20100904
		 * RRULE:FREQ=DAILY;COUNT=20060321T220000Z;UNTIL=20100904
		 * RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU
		 * FREQ=YEARLY;BYMONTH=4;BYDAY=1SU
		 * FREQ=WEEKLY;BYDAY=Tu;INTERVAL=2 // every second Tuesday
		 * 
		 * */
		public var FREQ:String;
		
		
		//UNTILL examples
		/**
		 * UNTIL=20100904
		 * RRULE:FREQ=DAILY;UNTIL=20060321T220000Z
		 * */
		public var UNTIL:String;
		public var COUNT:String;
		
		public function get RRULE():String {
			return "FREQ="+FREQ+";UNTILL";
		}
		
		public function toString():String {
			var recStr:String = "DTSTART;VALUE=DATE:"+DTSTART;
			if (DTEND) recStr += "\r\nDTEND;VALUE=DATE:"+DTEND;
			if (rule) {
				recStr += "\r\nRRULE:"+rule;
				if (INTERVAL) recStr += ";INTERVAL="+INTERVAL;
				if (UNTIL) recStr+= ";UNTIL:"+UNTIL;
				else if (COUNT) recStr += ";COUNT:"+COUNT;
			}
			return recStr;
		}
		
		public var rule:String;
	}
}