require "spec_helper"
require "ostruct"

describe DwollaV2::Response do
  let!(:raw_response) {
    OpenStruct.new status: 200,
                   response_headers: { location: "https://foo.bar" },
                   body: DwollaV2::SuperHash[foo: "bar"]
  }

  it "#status" do
    response = DwollaV2::Response.new raw_response
    expect(response.status).to be raw_response.status
  end

  it "#headers" do
    response = DwollaV2::Response.new raw_response
    expect(response.headers).to eq raw_response.response_headers
  end

  it "#respond_to?" do
    response = DwollaV2::Response.new raw_response
    expect(response.respond_to? :foo).to be true
    expect(response.respond_to? :bar).to be false
  end

  it "#is_a?" do
    response = DwollaV2::Response.new raw_response
    expect(response.is_a? DwollaV2::Response).to be true
    expect(response.is_a? DwollaV2::SuperHash).to be true
  end

  it "#kind_of?" do
    response = DwollaV2::Response.new raw_response
    expect(response.kind_of? DwollaV2::Response).to be true
    expect(response.kind_of? DwollaV2::SuperHash).to be true
  end

  it "#==" do
    response = DwollaV2::Response.new raw_response
    expect(response).to eq response
    expect(response).to eq raw_response.body
  end

  it "#method_missing" do
    response = DwollaV2::Response.new raw_response
    expect(response.foo).to eq raw_response.body.foo
  end
end
