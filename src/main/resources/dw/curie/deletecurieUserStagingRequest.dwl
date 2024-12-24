%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"allOrNone": true,
	"collateSubrequests": false,
	"compositeRequest": flatten (flatten ([
		{
		"method": "GET",
		"url": Mule::p('sfdc.urlREST.query') ++ "SELECT+Email+From+User+Where+External_Id__c+=+'" ++ vars.employeeId default ""  ++"'+LIMIT+1",
		"referenceId": "getUserEmail" 
	}
		,{
		"method": "POST",
		"url": Mule::p('sfdc.urlREST.sobject') ++ "Staging__c/",
		"referenceId": "userStaging",
		"httpHeaders": {
			"Sforce-Auto-Assign": (Mule::p('sfdc.case.autoAssign') default "true")
		},
		"body": {
			External_Id__c: vars.employeeId,
			Is_Active__c: "false",
			Email__c: "@{getUserEmail.records[0].Email}",
			Reason__c: "Curie requested to delete",
			Source__c: "Curie"
		}
	}]))
}