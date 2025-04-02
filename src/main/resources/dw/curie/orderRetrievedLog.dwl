%dw 2.0
output application/json
---
{
	"correlationId": vars.correlationId,
	"message": "ORDER RETRIEVED: User provision order has been retrieved",
	"orderDetails": {
		"type": "GET",
		"employeeId": vars.employeeId,
		"username": payload.compositeResponse[0].body.records[0].Username,
		"email": payload.compositeResponse[0].body.records[0].Email,
		"status": payload.compositeResponse[0].httpStatusCode,
		"timestamp": now(),
		"allVariables": vars
	}
}