package com.code11.google.calendar.services
{
	
	import com.code11.google.login.AuthenticatedUser;
	import com.adobe.serializers.json.JSONEncoder;
	import com.code11.google.calendar.util.CalendarUtil;
	import com.code11.google.calendar.util.Recurrence;
	import com.code11.google.calendar.valueObjects.*;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.messaging.ChannelSet;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.Operation;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ObjectProxy;
	
	public class GoogleCalendarService extends ServiceBase {
		
		public function logMessage(logMessage:String, logLevel:String):void {
		}
		
		private var calendarService:ServiceBase;
		
		public function GoogleCalendarService() {
			super("http://www.google.com/calendar/feeds/default/");
		}
		
		public function getSettings(user:AuthenticatedUser):void {
			
		}
		
		override protected function init():void {
			// initialize service control
			super.init();
			channelSet = new ChannelSet();
			channelSet.channels = [new AuthDirectHTTPChannel("directChannel","")]
			
			var operations:Array = new Array();
			var operation:mx.rpc.http.Operation;
			var argsArray:Array;
			
			operation = new mx.rpc.http.Operation(null, "allcalendars");
			operation.url = "allcalendars/full?alt=jsonc"
			operation.method = "GET";
			operation.serializationFilter = serializer;
			operation.resultType = AllCalendarResponse;
			operations.push(operation);
			
			operation = new mx.rpc.http.Operation(null, "owncalendars");
			operation.url = "owncalendars/full?alt=jsonc";
			operation.method = "GET";
			operation.serializationFilter = serializer;
			operation.resultType = AllCalendarResponse;
			operations.push(operation);
			
			operation = new mx.rpc.http.Operation(null, "createCalendar");
			operation.url = "owncalendars/full?alt=jsonc";
			operation.method = "POST";
			//operation.argumentNames = ["data"];
			operation.contentType = "application/json";
			operation.serializationFilter = serializer;
			operation.resultType = CalendarResponse;
			operations.push(operation);
			
			operation = new mx.rpc.http.Operation(null, "updateCalendar");
			operation.contentType = "application/json";
			operation.method = "PUT";
			operations.push(operation);
			
			
			operation = new mx.rpc.http.Operation(null, "deleteCalendar");
			operation.method = "DELETE";
			operations.push(operation);
			
			
			operation = new mx.rpc.http.Operation(null, "getEventsBetween");
			//operation.contentType = "application/json";
			operation.argumentNames = ["start-min","start-max"];
			operation.serializationFilter = serializer;
			operation.resultType = EventListResponse;
			operations.push(operation);
			
			
			operation = new mx.rpc.http.Operation(null, "addEvent");
			operation.contentType = "application/json";
			operation.method = "POST";
			operation.serializationFilter = serializer;
			operation.resultType = EventResponse;
			operations.push(operation);
			
			
			operation = new mx.rpc.http.Operation(null, "updateEvent");
			operation.contentType = "application/json";
			operation.method = "PUT";
			operation.serializationFilter = serializer;
			operation.resultType = EventResponse;
			operations.push(operation);
			
			
			operation = new mx.rpc.http.Operation(null, "deleteEvent");
			operation.contentType = "application/json";
			operation.method = "DELETE";
			operations.push(operation);
			
			operationList = operations;  
		}
		
		
		
		public function getAllCalendars():AsyncToken {
			var op:Operation = getOperation("allcalendars") as Operation;
			var token:AsyncToken = op.send();
			return token;//token.addResponder(new Responder(onAllCalendarsResponse, onAllCalendarsFault));
		}
		
		public function getOwnedCalendars():AsyncToken {
			var op:Operation = getOperation("owncalendars") as Operation;
			var token:AsyncToken = op.send();
			return token;
		}
		
		public function createCalendar(title:String,details:String = "",timeZone:String = "UTC",hidden:Boolean = false,color:String = "#2952A3", location:String = ""):AsyncToken	{
			var calendar:CalendarRequestVO = new CalendarRequestVO(title,details,timeZone,hidden,color,location);
			
			var enc:JSONEncoder = new JSONEncoder();
			var jsonRequest:String = enc.encode(calendar);
			var op:Operation = getOperation("createCalendar") as Operation;
			var token:AsyncToken = op.sendBody(jsonRequest);
			return token;
		}
		
		public function updateCalendar(calendar:CalendarVO):AsyncToken {
			var op:Operation = getOperation("updateCalendar") as Operation;
			
			var calRespo:CalendarResponse = new CalendarResponse();
			calRespo.apiVersion = "2.6";
			calRespo.data = calendar;
			
			op.url = calendar.selfLink;
			var enc:JSONEncoder = new JSONEncoder();
			var jsonRequest:String = enc.encode(calRespo);
			var token:AsyncToken = op.sendBody(jsonRequest);
			return token;
		}
		
		
		public function deleteCalendar(calendar:CalendarVO):AsyncToken {
			var op:Operation = getOperation("deleteCalendar") as Operation;
			op.url = calendar.selfLink;
			var token:AsyncToken = op.send();
			return token;
		}
		
		
		public function getEventsBetween(calendar:CalendarVO,startDate:Date,endDate:Date):AsyncToken {
			var startmin:String = CalendarUtil.dateToTimestamp(startDate);
			var startmax:String = CalendarUtil.dateToTimestamp(endDate);
			var op:Operation = getOperation("getEventsBetween") as Operation;
			op.url = calendar.eventFeedLink + "?alt=jsonc";
			var token:AsyncToken = op.send(startmin,startmax);
			return token;
		}
		
		public function addEvent(calendar:CalendarVO,startDate:Date,endDate:Date,title:String = "No Title",details:String = "",transparency:String = "opaque",status:String = "confirmed",location:String = "Bucharest",recurrence:String = ""):AsyncToken {
			if (!recurrence) {
				var timeRange:TimeRangeVO = new TimeRangeVO();
				timeRange.start = CalendarUtil.dateToTimestamp(startDate);
				timeRange.end = CalendarUtil.dateToTimestamp(endDate);
			} else {
				var recurrenceObj:Recurrence = new Recurrence();
				recurrenceObj.DTSTART = CalendarUtil.dateToSimpletime(startDate);
				recurrenceObj.DTEND =  CalendarUtil.dateToSimpletime(endDate);
				recurrenceObj.rule = recurrence;
			}
			var evReq:EventRequest = new EventRequest(title,details,transparency,status,location,timeRange,recurrenceObj.toString());
			var obj:Object = {};
			obj.data = evReq;
			
			var op:Operation = getOperation("addEvent") as Operation;
			op.url = calendar.eventFeedLink + "?alt=jsonc";
			
			var enc:JSONEncoder = new JSONEncoder();
			var jsonRequest:String = enc.encode(obj);
			var token:AsyncToken = op.sendBody(jsonRequest);
			return token;
		}
		
		
		public function updateEvent(event:EventVO):AsyncToken {
			var op:Operation = getOperation("updateEvent") as Operation;
			op.url = event.selfLink + "?alt=jsonc";
			
			var obj:Object = {};
			obj.data = event;
			
			var enc:JSONEncoder = new JSONEncoder();
			var jsonRequest:String = enc.encode(obj);
			var token:AsyncToken = op.sendBody(jsonRequest);
			return token;
		}
		
		public function deleteEvent(event:EventVO):AsyncToken {
			var op:Operation = getOperation("deleteEvent") as Operation;
			op.url = event.selfLink;
			op.headers = {"If-Match":"*"};
			var token:AsyncToken = op.send();
			return token;
		}
		
	}
}