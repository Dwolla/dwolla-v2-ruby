require "spec_helper"
require "ostruct"

describe DwollaV2::Response do
  let!(:raw_response) {
    OpenStruct.new status: 200,
                   headers: { location: "https://foo.bar" },
                   body: DwollaV2::SuperHash[foo: "bar"]
  }

  it "#inspect" do
    response = DwollaV2::Response.new raw_response
    expect(response.inspect).to eq '#<DwollaV2::Response response_status=200 response_headers={:location=>"https://foo.bar"} {"foo"=>"bar"}>'
  end

  it "#status" do
    response = DwollaV2::Response.new raw_response
    expect(response.response_status).to be raw_response.status
  end

  it "#response_headers" do
    response = DwollaV2::Response.new raw_response
    expect(response.response_headers).to eq raw_response.headers
  end

  it "#headers uses @response.response_headers if no @response.headers" do
    raw_response_no_headers = Struct.new(:status, :response_headers, :body)
      .new(raw_response.status, raw_response.headers, raw_response.body)
    response = DwollaV2::Response.new raw_response_no_headers
    expect(response.response_headers).to eq raw_response.headers
  end

  it "#headers returns nil if no @response.headers or @response.response_headers" do
    raw_response_no_headers_or_response_headers = Struct.new(:status, :body)
      .new(raw_response.status, raw_response.body)
    response = DwollaV2::Response.new raw_response_no_headers_or_response_headers
    expect(response.response_headers).to be nil
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
