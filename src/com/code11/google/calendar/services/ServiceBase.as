package com.code11.google.calendar.services {
	import com.adobe.serializers.json.JSONSerializationFilter;
	
	import mx.core.mx_internal;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.HTTPChannel;
	import mx.rpc.http.HTTPMultiService;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.SerializationFilter;

	use namespace mx_internal;
	
	public class ServiceBase extends HTTPMultiService {
		
		private static var _serializer:JSONSerializationFilter = new JSONSerializationFilter();
		
		public function ServiceBase(baseURL:String) {
			super(baseURL);
			init();
		}
		
		protected function get serializer():SerializationFilter{
			return _serializer;
		}
		
		protected function init():void{
			useProxy = true;
		}
		
		private var _directChannelSet:ChannelSet;
		override mx_internal function getDirectChannelSet():ChannelSet
		{
			if (_directChannelSet == null)
			{
				if(channelSet != null) {
					_directChannelSet = channelSet;
					return _directChannelSet;
				}
				
				var dcs:ChannelSet = new ChannelSet();
				dcs.addChannel(new AuthDirectHTTPChannel("direct_http_channel"));
				_directChannelSet = dcs;            
			}
			return _directChannelSet;  
		}
	}
}