require "spec_helper"

describe DwollaV2::Error do
  it ".raise!(String)" do
    expect {
      DwollaV2::Error.raise! ""
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

  it ".raise! :code => BadRequest" do
    expect {
      DwollaV2::Error.raise! :code => "BadRequest"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::BadRequestError
    }
  end

  it ".raise! :code => ValidationError" do
    expect {
      DwollaV2::Error.raise! :code => "ValidationError"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ValidationError
    }
  end

  it ".raise! :code => InvalidCredentials" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidCredentials"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidCredentialsError
    }
  end

  it ".raise! :code => InvalidAccessToken" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidAccessTokenError
    }
  end

  it ".raise! :code => ExpiredAccessToken" do
    expect {
      DwollaV2::Error.raise! :code => "ExpiredAccessToken"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ExpiredAccessTokenError
    }
  end

  it ".raise! :code => InvalidAccountStatus" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidAccountStatus"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidAccountStatusError
    }
  end

  it ".raise! :code => InvalidApplicationStatus" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidApplicationStatus"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidApplicationStatusError
    }
  end

  it ".raise! :code => InvalidScopes" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidScopes"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidScopesError
    }
  end

  it ".raise! :code => Forbidden" do
    expect {
      DwollaV2::Error.raise! :code => "Forbidden"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ForbiddenError
    }
  end

  it ".raise! :code => InvalidResourceState" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidResourceState"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidResourceStateError
    }
  end

  it ".raise! :code => NotFound" do
    expect {
      DwollaV2::Error.raise! :code => "NotFound"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::NotFoundError
    }
  end

  it ".raise! :code => MethodNotAllowed" do
    expect {
      DwollaV2::Error.raise! :code => "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::MethodNotAllowedError
    }
  end

  it ".raise! :code => MethodNotAllowed" do
    expect {
      DwollaV2::Error.raise! :code => "MethodNotAllowed"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::MethodNotAllowedError
    }
  end

  it ".raise! :code => InvalidVersion" do
    expect {
      DwollaV2::Error.raise! :code => "InvalidVersion"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::InvalidVersionError
    }
  end

  it ".raise! :code => ServerError" do
    expect {
      DwollaV2::Error.raise! :code => "ServerError"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::ServerError
    }
  end

  it ".raise! :code => RequestTimeout" do
    expect {
      DwollaV2::Error.raise! :code => "RequestTimeout"
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::RequestTimeoutError
    }
  end

  it "#initialize sets error" do
    error = "error"
    e = DwollaV2::Error.new :error => error
    expect(e.error).to eq error
  end

  it "#initialize sets error_description" do
    error_description = "error_description"
    e = DwollaV2::Error.new :error_description => error_description
    expect(e.error_description).to eq error_description
  end

  it "#initialize sets error_uri" do
    error_uri = "error_uri"
    e = DwollaV2::Error.new :error_uri => error_uri
    expect(e.error_uri).to eq error_uri
  end

  it "#initialize sets code" do
    code = "code"
    e = DwollaV2::Error.new :code => code
    expect(e.code).to eq code
  end

  it "#initialize sets message" do
    message = "message"
    e = DwollaV2::Error.new :message => message
    expect(e.message).to eq message
  end

  it "#initialize sets _links" do
    _links = "_links"
    e = DwollaV2::Error.new :_links => _links
    expect(e._links).to eq _links
  end

  it "#initialize sets _embedded" do
    _embedded = "_embedded"
    e = DwollaV2::Error.new :_embedded => _embedded
    expect(e._embedded).to eq _embedded
  end
end
