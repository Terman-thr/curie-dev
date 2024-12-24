%dw 2.0
output application/json skipNullOn="everywhere"
var requestStatus = ((payload.compositeResponse[0].httpStatusCode default 300) < 300) default false
---
{
  status: if(requestStatus) "Success" else "Failure",
  statusCode: if(requestStatus) "200" else "400",
  description: if(requestStatus) "User (EmployeeId: " ++ vars.employeeId ++ ") was successfully fetched" else 
   (if (!isEmpty(payload.compositeResponse.body[1].message)) payload.compositeResponse.body[1].message else payload.compositeResponse.body[0].message),
  source: "Curie",
  ( responsePayload: {
  	"salesforceId": payload."compositeResponse"[0].body.records[0]."Id",
  	"firstName": payload."compositeResponse"[0].body.records[0]."FirstName",
  	"lastName": payload."compositeResponse"[0].body.records[0]."LastName",
  	"email": payload."compositeResponse"[0].body.records[0]."Email",
  	"alias": payload."compositeResponse"[0].body.records[0]."Alias",
  	"username": payload."compositeResponse"[0].body.records[0]."Username",
  	"nickName": payload."compositeResponse"[0].body.records[0]."CommunityNickname",
  	"timeZone": payload."compositeResponse"[0].body.records[0]."TimeZoneSidKey",
  	"isActive": payload."compositeResponse"[0].body.records[0]."IsActive",
  	"profile": payload."compositeResponse"[1].body.records[0]."Name",

  }) if (requestStatus)
}
