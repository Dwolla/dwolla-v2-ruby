require "spec_helper"

describe Dwolla::Error do
  it ".raise!(String)" do
    expect {
      Dwolla::Error.raise! ""
    }.to raise_error {|e|
      expect(e.class).to be Dwolla::Error
    }
  end

  it ".raise!({})" do
    expect {
      Dwolla::Error.raise!({})
    }.to raise_error {|e|
      expect(e.class).to be Dwolla::Error
    }
  end

  it ".raise! :error => invalid_request" do
    expect {
      Dwolla::Error.raise! :error => "invalid_request"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidRequestError
    }
  end

  it ".raise! :error => invalid_client" do
    expect {
      Dwolla::Error.raise! :error => "invalid_client"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidClientError
    }
  end

  it ".raise! :error => invalid_grant" do
    expect {
      Dwolla::Error.raise! :error => "invalid_grant"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidGrantError
    }
  end

  it ".raise! :error => invalid_scope" do
    expect {
      Dwolla::Error.raise! :error => "invalid_scope"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidScopeError
    }
  end

  it ".raise! :error => unauthorized_client" do
    expect {
      Dwolla::Error.raise! :error => "unauthorized_client"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::UnauthorizedClientError
    }
  end

  it ".raise! :error => access_denied" do
    expect {
      Dwolla::Error.raise! :error => "access_denied"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::AccessDeniedError
    }
  end

  it ".raise! :error => unsupported_response_type" do
    expect {
      Dwolla::Error.raise! :error => "unsupported_response_type"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::UnsupportedResponseTypeError
    }
  end

  it ".raise! :error => server_error" do
    expect {
      Dwolla::Error.raise! :error => "server_error"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::ServerError
    }
  end

  it ".raise! :error => temporarily_unavailable" do
    expect {
      Dwolla::Error.raise! :error => "temporarily_unavailable"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::TemporarilyUnavailableError
    }
  end

  it ".raise! :error => unsupported_grant_type" do
    expect {
      Dwolla::Error.raise! :error => "unsupported_grant_type"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::UnsupportedGrantTypeError
    }
  end

  it ".raise! :code => BadRequest" do
    expect {
      Dwolla::Error.raise! :code => "BadRequest"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::BadRequestError
    }
  end

  it ".raise! :code => ValidationError" do
    expect {
      Dwolla::Error.raise! :code => "ValidationError"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::ValidationError
    }
  end

  it ".raise! :code => InvalidCredentials" do
    expect {
      Dwolla::Error.raise! :code => "InvalidCredentials"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidCredentialsError
    }
  end

  it ".raise! :code => InvalidAccessToken" do
    expect {
      Dwolla::Error.raise! :code => "InvalidAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidAccessTokenError
    }
  end

  it ".raise! :code => ExpiredAccessToken" do
    expect {
      Dwolla::Error.raise! :code => "ExpiredAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::ExpiredAccessTokenError
    }
  end

  it ".raise! :code => InvalidAccountStatus" do
    expect {
      Dwolla::Error.raise! :code => "InvalidAccountStatus"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidAccountStatusError
    }
  end

  it ".raise! :code => InvalidApplicationStatus" do
    expect {
      Dwolla::Error.raise! :code => "InvalidApplicationStatus"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidApplicationStatusError
    }
  end

  it ".raise! :code => InvalidScopes" do
    expect {
      Dwolla::Error.raise! :code => "InvalidScopes"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidScopesError
    }
  end

  it ".raise! :code => Forbidden" do
    expect {
      Dwolla::Error.raise! :code => "Forbidden"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::ForbiddenError
    }
  end

  it ".raise! :code => InvalidResourceState" do
    expect {
      Dwolla::Error.raise! :code => "InvalidResourceState"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidResourceStateError
    }
  end

  it ".raise! :code => NotFound" do
    expect {
      Dwolla::Error.raise! :code => "NotFound"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::NotFoundError
    }
  end

  it ".raise! :code => MethodNotAllowed" do
    expect {
      Dwolla::Error.raise! :code => "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::MethodNotAllowedError
    }
  end

  it ".raise! :code => MethodNotAllowed" do
    expect {
      Dwolla::Error.raise! :code => "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::MethodNotAllowedError
    }
  end

  it ".raise! :code => InvalidVersion" do
    expect {
      Dwolla::Error.raise! :code => "InvalidVersion"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidVersionError
    }
  end

  it ".raise! :code => ServerError" do
    expect {
      Dwolla::Error.raise! :code => "ServerError"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::ServerError
    }
  end

  it ".raise! :code => RequestTimeout" do
    expect {
      Dwolla::Error.raise! :code => "RequestTimeout"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::RequestTimeoutError
    }
  end

  it "#initialize sets error" do
    error = "error"
    e = Dwolla::Error.new :error => error
    expect(e.error).to eq error
  end

  it "#initialize sets error_description" do
    error_description = "error_description"
    e = Dwolla::Error.new :error_description => error_description
    expect(e.error_description).to eq error_description
  end

  it "#initialize sets error_uri" do
    error_uri = "error_uri"
    e = Dwolla::Error.new :error_uri => error_uri
    expect(e.error_uri).to eq error_uri
  end

  it "#initialize sets code" do
    code = "code"
    e = Dwolla::Error.new :code => code
    expect(e.code).to eq code
  end

  it "#initialize sets message" do
    message = "message"
    e = Dwolla::Error.new :message => message
    expect(e.message).to eq message
  end

  it "#initialize sets _links" do
    _links = "_links"
    e = Dwolla::Error.new :_links => _links
    expect(e._links).to eq _links
  end

  it "#initialize sets _embedded" do
    _embedded = "_embedded"
    e = Dwolla::Error.new :_embedded => _embedded
    expect(e._embedded).to eq _embedded
  end
end
