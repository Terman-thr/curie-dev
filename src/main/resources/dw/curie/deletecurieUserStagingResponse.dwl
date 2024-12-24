%dw 2.0
output application/json skipNullOn="everywhere"
var requestStatus = ((payload.compositeResponse[1].httpStatusCode default 300) < 300) default false
---
{
  status: if(requestStatus) "Success" else "Failure",
  statusCode: if(requestStatus) "200" else "400",
  description: if(requestStatus) "User (EmployeeId: " ++ vars.employeeId ++ ") updated into staging " else 
  payload.compositeResponse.body[1].message[0],
  source: "Curie",
  (responsePayload: {
    "messageList": payload.compositeResponse filter ($.referenceId contains 'userStaging') map() ->
      {
        "salesforceId": $.body."id",
        "employeeId":  vars.employeeId
      }
  }) if (requestStatus)
}