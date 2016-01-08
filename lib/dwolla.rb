require "base64"
require "uri"
require "json"
require "forwardable"

require "faraday"
require "faraday_middleware"

require "dwolla/version"
require "dwolla/client"
require "dwolla/portal"
require "dwolla/auth"
require "dwolla/token"
require "dwolla/response"
require "dwolla/error"
require "dwolla/util"

# OAuth errors https://tools.ietf.org/html/rfc6749
require "dwolla/errors/invalid_request_error"
require "dwolla/errors/invalid_client_error"
require "dwolla/errors/invalid_grant_error"
require "dwolla/errors/invalid_scope_error"
require "dwolla/errors/unauthorized_client_error"
require "dwolla/errors/access_denied_error"
require "dwolla/errors/unsupported_response_type_error"
require "dwolla/errors/server_error"
require "dwolla/errors/temporarily_unavailable_error"
require "dwolla/errors/unsupported_grant_type_error"

# Dwolla errors https://docsv2.dwolla.com/#errors
require "dwolla/errors/bad_request_error"
require "dwolla/errors/validation_error"
require "dwolla/errors/invalid_credentials_error"
require "dwolla/errors/invalid_access_token_error"
require "dwolla/errors/expired_access_token_error"
require "dwolla/errors/invalid_account_status_error"
require "dwolla/errors/invalid_application_status_error"
require "dwolla/errors/invalid_scopes_error"
require "dwolla/errors/forbidden_error"
require "dwolla/errors/invalid_resource_state_error"
require "dwolla/errors/not_found_error"
require "dwolla/errors/method_not_allowed_error"
require "dwolla/errors/invalid_version_error"
require "dwolla/errors/request_timeout_error"

module Dwolla
end
