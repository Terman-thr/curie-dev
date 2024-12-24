%dw 2.0
output application/json skipNullOn = "everywhere"
var userProfileList = Mule::p('user.profileList')  splitBy ","
fun isProfileContains(profile: String) = (userProfileList filter ($ == profile) map ()-> true )

---
{
	"allOrNone": true,
	"collateSubrequests": false,
	"compositeRequest": flatten (flatten ([

 	({
		"method": "GET",
		"url": Mule::p('sfdc.urlREST.query') ++ "SELECT+Id+From+Profile+Where+Name+=+'" ++ payload.profile default ""  ++"'+LIMIT+1",
		"referenceId": "getProfileId" 
	}) if payload.profile?,
 	
 	{
		"method": "PATCH",
		"url": Mule::p('sfdc.urlREST.sobject') ++ "User/FederationIdentifier/" ++ vars.employeeId,
		"referenceId": "user" ,
		"httpHeaders": {
			"Sforce-Auto-Assign": (Mule::p('sfdc.case.autoAssign') default "true")
		},
		"body": {
			(FirstName: payload.firstName) if payload.firstName?,
			(LastName: payload.lastName) if payload.lastName?,
			(Alias: payload.alias) if payload.alias?,
			(Email: payload.email) if payload.email?,
			(Username: payload.userName) if payload.userName?,
			(CommunityNickname: payload.nickName) if payload.nickName?,
			(TimeZoneSidKey: payload.timeZone) if payload.timeZone?,
			(Agent_Zendesk_ID__c: payload.agentZendeskId) if payload.agentZendeskId?,
			(Site_Location__c: payload.siteLocation) if payload.siteLocation?,
			(Vendor_Company__c: payload.vendorCompany) if payload.vendorCompany?,
			(Vendor_Email__c:  payload.vendorEmail) if (payload.vendorEmail? and sizeOf(trim(payload.vendorEmail))>0),
			("ProfileId": "@{getProfileId.records[0].Id}" ) if payload.profile?,
			IsActive: "true",
			"UserPermissionsInteractionUser": true,
			"unbabelapi__Unbabel_Language__c": "en:English",
			("UserPermissionsSupportUser": isProfileContains(payload.profile) [0] default false) if payload.profile?
			
		}
	}
      
	]))
}