%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	"allOrNone": true,
	"collateSubrequests": false,
	"compositeRequest": flatten (flatten ([
 	
 	{
		"method": "GET",
		"url": Mule::p('sfdc.urlREST.query') ++ "select+Id+,+FirstName+,+LastName+,+Email+,+Alias+,+ProfileId+,+UserRoleId+,+Username+,+CommunityNickname+,+TimeZoneSidKey+,+IsActive+,+Site_Location__c+,+Vendor_Company__c+,+Vendor_Email__c+from+User+where+FederationIdentifier+=+'" ++ vars.employeeId  ++"'+LIMIT+1",
		"referenceId": "getUserDetails" 
	},{
		"method": "GET",
		"url": Mule::p('sfdc.urlREST.query') ++ "SELECT+Name+From+Profile+Where+Id+='@{getUserDetails.records[0].ProfileId}'+LIMIT+1",
		"referenceId": "getProfileId" 
	}
      
	]))
}