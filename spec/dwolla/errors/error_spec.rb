require "spec_helper"

describe Dwolla::Error do
  it ".raise!({})" do
    expect {
      Dwolla::Error.raise!({})
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
    }
  end

  it ".raise! :error => invalid_client" do
    expect {
      Dwolla::Error.raise! :error => "invalid_client"
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::InvalidClientError
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
end
