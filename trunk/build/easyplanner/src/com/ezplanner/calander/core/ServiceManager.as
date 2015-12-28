package com.ezplanner.calander.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.Application;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class ServiceManager extends EventDispatcher {
		
		private var _wsdls:Array = [];
		private var _hostName:String = "http://smf-ssbtteams.photoninfotech.com/_vti_bin/smfservices/"; //"http://smf-ssbtservices.photoninfotech.com/services/";
		private var _loadedWsdlsCount:int = 0;
		private static var _instance:ServiceManager;
		private var service:RemoteObject;
		
		public function ServiceManager() {
		}
		
		public static function getInstance():ServiceManager {
			if(_instance == null) {
				_instance = new ServiceManager();
			}
			
			return _instance;
		}
		
		public function updateService(service:RemoteObject):void {
			this.service = service;
		}
		
		public function call(method:String, resultCallback:Function, faultCallback:Function, passback:Object = null, ...args):void {
			if(service == null) {
				return;
			}
			
			var token:AsyncToken = service.getOperation(method).send.apply(null, args);
			var responder:IResponder = new Responder(
				function result(e:ResultEvent):void {
					execute(resultCallback, e, passback);
				},
				function fault(e:FaultEvent):void {
					execute(faultCallback, e, passback);
				}
			);
			
			token.addResponder(responder);
		}
		
		private function execute(callback:Function, e:*, passback:Object = null):void {
			if(passback == null) {
				callback(e);
			} else {
				callback(e, passback);
			}
		}
	}
}