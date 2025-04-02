%dw 2.0
output application/json
---
{
	"correlationId": vars.correlationId,
	"message": "ORDER STAGING CANCELED: User provision staging order has been canceled",
	"orderDetails": {
		"type": "DELETE_STAGING",
		"employeeId": vars.employeeId,
		"status": (payload.compositeResponse[1].body.success default ((payload.compositeResponse[1].httpStatusCode as Number) <= 299)),
		"timestamp": now(),
		"allVariables": vars
	}
}