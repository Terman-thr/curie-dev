%dw 2.0
output application/json
---
{
  status: "Failure",
  statusCode: error.exception.errorMessage.typedAttributes.statusCode default "500",
  source: "Salesforce",
  "correlationId": vars.correlationId,
  errorType: error.errorType.asString,
  errorPayload: {
    error: error.detailedDescription default "unknown error" ++ "-" ++ (write(error.errorMessage.payload default "unknown"))
  }
}