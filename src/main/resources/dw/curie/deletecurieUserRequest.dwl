%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"allOrNone": true,
	"collateSubrequests": false,
	"compositeRequest": flatten (flatten ([{
		"method": "PATCH",
		"url": Mule::p('sfdc.urlREST.sobject') ++ "User/External_Id__c/" ++ vars.employeeId,
		"referenceId": "user",
		"httpHeaders": {
			"Sforce-Auto-Assign": (Mule::p('sfdc.case.autoAssign') default "true")
		},
		"body": {
			IsActive: "false"
		}
	}]))
}