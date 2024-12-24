%dw 2.0
output application/json skipNullOn = "everywhere"
var userProfileList = Mule::p('user.profileList')  splitBy ","
fun isProfileContains(profile: String) = (userProfileList filter ($ == profile) map ()-> true )

---
{
	"allOrNone": true,
	"collateSubrequests": false,
	"compositeRequest": flatten (flatten ([
 payload map [
 	{
		"method": "GET",
		"url": Mule::p('sfdc.urlREST.query') ++ "SELECT+Id+From+Profile+Where+Name+=+'" ++ ($.profile default "") ++"'+LIMIT+1",
		"referenceId": "getProfileId" ++$$
	},
 	
 	{
		"method": "POST",
		"url": Mule::p('sfdc.urlREST.sobject') ++ "User/",
		"referenceId": "user" ++$$,
		"httpHeaders": {
			"Sforce-Auto-Assign": (Mule::p('sfdc.case.autoAssign') default "true")
		},
		"body": {
			(FirstName: $.firstName) if $.firstName?,
			(LastName: $.lastName) if $.lastName?,
			(Alias: $.alias) if $.alias?,
			(Email: $.email) if $.email?,
			(Username: $.userName) if $.userName?,
			(CommunityNickname: $.nickName) if $.nickName?,
			(TimeZoneSidKey: $.timeZone) if $.timeZone?,
			(ExternalId__c: $.externalId) if $.externalId?,
			IsActive: "true",
			"UserRoleId": Mule::p("sobject.user.role"),
			"ProfileId": "@{getProfileId"++$$++".records[0].Id}",
			"EmailEncodingKey": Mule::p("sobject.user.emailEncodingKey"),
			"LocaleSidKey": Mule::p("sobject.user.localeSidKey"),
			"LanguageLocaleKey": Mule::p("sobject.user.languageLocaleKey"),
			"UserPermissionsInteractionUser": true,
			("UserPermissionsSupportUser": isProfileContains($.profile) [0] default false) if $.profile?
			
		}
	}]
      
	]))
}