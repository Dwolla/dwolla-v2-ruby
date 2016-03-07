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

  it "#message" do
    message = "message"
    e = DwollaV2::Error.new :message => message
    expect(e.message).to eq message
  end

  it "#[] passes key to error" do
    error = "error"
    e = DwollaV2::Error.new :error => error
    expect(e[:error]).to eq error
  end

  it "#[] returns nil if error is HTML" do
    e = DwollaV2::Error.new "string"
    expect(e[:foo]).to be nil
  end

  it "#method_missing passes method to error" do
    error = "error"
    e = DwollaV2::Error.new :error => error
    expect(e.error).to eq error
  end

  it "#method_missing returns nil if error is HTML" do
    e = DwollaV2::Error.new "string"
    expect(e[:foo]).to be nil
  end

  it "#to_s" do
    message = "message"
    e = DwollaV2::Error.new :message => message
    expect(e.to_s).to eq "{:message=>\"message\"}"
  end
end
