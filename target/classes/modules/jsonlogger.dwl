%dw 2.0
fun masker(pld,fields) = pld match {
    case a is Object -> a mapObject ((value, key, index) -> (key): if(fields contains(key as String)) "******" else value)
    case a is Array -> a map ((item,index) -> masker(item,fields))
    case a is String -> a
    case a is Number -> a
    else -> "No Match"
  }
---
{
	"timestamp": now() >> "America/New_York",
	"uuid": payload.uuid default "",
    "ip": payload.ip default "",
	"appName": payload.appName default "",
	"flow": payload.flowName default "",
	"status": payload.status default "",
	("message": masker(payload.message,payload.maskFields default [])) if(! isEmpty(payload.message))
}



/*
Paste this below script in your logger component 
************************************************************************************
NOTE:
1) For logging anything, always use this script and decide what needs to be logged.
2) Change the 'status' key to "Started", "In-Progress", "Ended", "Error" as per you logger placement in the flow.
3) If you don't want to print the message/payload pass null in the "message" key.
4) If you want to mask certain keys in your message/payload, then
   pass the message/payload in "message" key and masked fields in "maskFields" key as an array ["key1","key2"]
************************************************************************************
%dw 2.0
import modules::jsonlogger
output application/json
---
jsonlogger::main(payload: {
	"status": "Started",
	"uuid": vars.uuid,
	"message": payload,
	"maskFields": [],
	"appName": app.name,
	"ip": server.ip,
	"flowName": flow.name
})
************************************************************************************
*/
