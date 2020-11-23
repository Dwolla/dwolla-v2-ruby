require "spec_helper"
require "ostruct"

describe DwollaV2::Error do
  it ".raise!(String)" do
    expect {
      DwollaV2::Error.raise! "uh oh"
    }.to raise_error {|e|
      expect(e.class).to be DwollaV2::Error
    }
  end

  it ".raise!({})" do
    expect {
      DwollaV2::Error.raise!({})
    }.to raise_error {|e|
      expect(e.class).to be DwollaV2::Error
    }
  end

  it ".raise! :error => invalid_request" do
    expect {
      DwollaV2::Error.raise! :error => "invalid_request"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidRequestError
    }
  end

  it ".raise! :error => invalid_client" do
    expect {
      DwollaV2::Error.raise! :error => "invalid_client"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidClientError
    }
  end

  it ".raise! :error => invalid_grant" do
    expect {
      DwollaV2::Error.raise! :error => "invalid_grant"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidGrantError
    }
  end

  it ".raise! :error => invalid_scope" do
    expect {
      DwollaV2::Error.raise! :error => "invalid_scope"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidScopeError
    }
  end

  it ".raise! :error => unauthorized_client" do
    expect {
      DwollaV2::Error.raise! :error => "unauthorized_client"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::UnauthorizedClientError
    }
  end

  it ".raise! :error => access_denied" do
    expect {
      DwollaV2::Error.raise! :error => "access_denied"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::AccessDeniedError
    }
  end

  it ".raise! :error => unsupported_response_type" do
    expect {
      DwollaV2::Error.raise! :error => "unsupported_response_type"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::UnsupportedResponseTypeError
    }
  end

  it ".raise! :error => server_error" do
    expect {
      DwollaV2::Error.raise! :error => "server_error"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ServerError
    }
  end

  it ".raise! :error => temporarily_unavailable" do
    expect {
      DwollaV2::Error.raise! :error => "temporarily_unavailable"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::TemporarilyUnavailableError
    }
  end

  it ".raise! :error => unsupported_grant_type" do
    expect {
      DwollaV2::Error.raise! :error => "unsupported_grant_type"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::UnsupportedGrantTypeError
    }
  end

  it ".raise! code: BadRequest" do
    expect {
      DwollaV2::Error.raise! code: "BadRequest"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::BadRequestError
    }
  end

  it ".raise! code: ValidationError" do
    expect {
      DwollaV2::Error.raise! code: "ValidationError"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ValidationError
    }
  end

  it ".raise! code: InvalidCredentials" do
    expect {
      DwollaV2::Error.raise! code: "InvalidCredentials"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidCredentialsError
    }
  end

  it ".raise! code: InvalidAccessToken" do
    expect {
      DwollaV2::Error.raise! code: "InvalidAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidAccessTokenError
    }
  end

  it ".raise! code: ExpiredAccessToken" do
    expect {
      DwollaV2::Error.raise! code: "ExpiredAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ExpiredAccessTokenError
    }
  end

  it ".raise! code: InvalidAccountStatus" do
    expect {
      DwollaV2::Error.raise! code: "InvalidAccountStatus"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidAccountStatusError
    }
  end

  it ".raise! code: InvalidApplicationStatus" do
    expect {
      DwollaV2::Error.raise! code: "InvalidApplicationStatus"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidApplicationStatusError
    }
  end

  it ".raise! code: InvalidScopes" do
    expect {
      DwollaV2::Error.raise! code: "InvalidScopes"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidScopesError
    }
  end

  it ".raise! code: Forbidden" do
    expect {
      DwollaV2::Error.raise! code: "Forbidden"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ForbiddenError
    }
  end

  it ".raise! code: InvalidResourceState" do
    expect {
      DwollaV2::Error.raise! code: "InvalidResourceState"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidResourceStateError
    }
  end

  it ".raise! code: NotFound" do
    expect {
      DwollaV2::Error.raise! code: "NotFound"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::NotFoundError
    }
  end

  it ".raise! code: MethodNotAllowed" do
    expect {
      DwollaV2::Error.raise! code: "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::MethodNotAllowedError
    }
  end

  it ".raise! code: MethodNotAllowed" do
    expect {
      DwollaV2::Error.raise! code: "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::MethodNotAllowedError
    }
  end

  it ".raise! code: InvalidVersion" do
    expect {
      DwollaV2::Error.raise! code: "InvalidVersion"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidVersionError
    }
  end

  it ".raise! code: ServerError" do
    expect {
      DwollaV2::Error.raise! code: "ServerError"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ServerError
    }
  end

  it ".raise! code: RequestTimeout" do
    expect {
      DwollaV2::Error.raise! code: "RequestTimeout"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::RequestTimeoutError
    }
  end

  it ".raise! code: TooManyRequests" do
    expect {
      DwollaV2::Error.raise! code: "TooManyRequests"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::TooManyRequestsError
    }
  end

  it ".raise! code: Conflict" do
    expect {
      DwollaV2::Error.raise! code: "Conflict"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ConflictError
    }
  end

  it ".raise! code: DuplicateResource" do
    expect {
      DwollaV2::Error.raise! code: "DuplicateResource"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::DuplicateResourceError
    }
  end

  it ".raise! code: MaxNumberOfResources" do
    expect {
      DwollaV2::Error.raise! code: "MaxNumberOfResources"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::MaxNumberOfResourcesError
    }
  end
  
  it ".raise! Struct(status, headers, body)" do
    status = 400
    headers = { foo: "bar" }
    body = { code: "RequestTimeout" }
    expect {
      DwollaV2::Error.raise! OpenStruct.new(status: status, headers: headers, body: body)
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::RequestTimeoutError
    }
  end

  it "#status" do
    status = 400
    expect {
      DwollaV2::Error.raise! OpenStruct.new(status: status, body: nil)
    }.to raise_error {|e|
      expect(e.status).to eq status
    }
  end

  it "#headers" do
    headers = { foo: "bar" }
    expect {
      DwollaV2::Error.raise! OpenStruct.new(headers: headers, body: nil)
    }.to raise_error {|e|
      expect(e.headers).to eq headers
    }
  end

  it "#headers uses @response.response_headers if no @response.headers" do
    response_headers = { foo: "bar" }
    expect {
      DwollaV2::Error.raise! Struct.new(:response_headers, :body).new(response_headers, nil)
    }.to raise_error {|e|
      expect(e.headers).to eq response_headers
    }
  end

  it "#headers returns nil if no @response.headers or @response.response_headers" do
    expect {
      DwollaV2::Error.raise! Struct.new(:body).new
    }.to raise_error {|e|
      expect(e.headers).to be nil
    }
  end

  it "#to_s" do
    error = { "message" => "message" }
    expect {
      DwollaV2::Error.raise! error
    }.to raise_error {|e|
      expect(e.to_s).to eq error.to_s
    }
  end

  it "#to_json" do
    error = { "message" => "message" }
    expect {
      DwollaV2::Error.raise! error
    }.to raise_error {|e|
      expect(e.to_json).to eq error.to_json
    }
  end

  it "#respond_to?" do
    expect {
      DwollaV2::Error.raise! foo: "bar"
    }.to raise_error {|e|
      expect(e.respond_to? :foo).to be true
      expect(e.respond_to? :bar).to be false
    }
  end

  it "#is_a?" do
    expect {
      DwollaV2::Error.raise! foo: "bar"
    }.to raise_error {|e|
      expect(e.is_a? DwollaV2::Error).to be true
      expect(e.is_a? DwollaV2::SuperHash).to be true
    }
  end

  it "#kind_of?" do
    expect {
      DwollaV2::Error.raise! foo: "bar"
    }.to raise_error {|e|
      expect(e.kind_of? DwollaV2::Error).to be true
      expect(e.kind_of? DwollaV2::SuperHash).to be true
    }
  end

  it "#==" do
    error = { foo: "bar" }
    expect {
      DwollaV2::Error.raise! error
    }.to raise_error {|e|
      expect(e).to eq e
      expect(e).to eq error
    }
  end

  it "#method_missing passes method to error" do
    error = "error"
    expect {
      DwollaV2::Error.raise! :error => error
    }.to raise_error {|e|
      expect(e.error).to eq error
      expect(e[:error]).to eq error
    }
  end

  it "#message" do
    error = { "message" => "message" }
    expect {
      DwollaV2::Error.raise! error
    }.to raise_error {|e|
      expect(e.message).to eq error.to_s
    }
  end

  it "#to_str" do
    error = { "message" => "message" }
    expect {
      DwollaV2::Error.raise! error
    }.to raise_error {|e|
      expect(e.to_str).to be nil
    }
  end
end
