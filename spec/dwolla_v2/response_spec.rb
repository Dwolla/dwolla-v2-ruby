require "spec_helper"

describe DwollaV2::Response do
  let!(:raw_response) {
    Class.new do
      def status
        200
      end
      def headers
        { location: "https://foo.bar" }
      end
      def body
        { foo: "bar" }
      end
    end.new
  }

  it "forwards #status to @response" do
    response = DwollaV2::Response.new raw_response
    expect(response.status).to be raw_response.status
  end

  it "forwards #headers to @response" do
    response = DwollaV2::Response.new raw_response
    expect(response.headers).to eq raw_response.headers
  end

  it "forwards #body to @response" do
    response = DwollaV2::Response.new raw_response
    expect(response.body).to eq raw_response.body
  end

  it "forwards #[](key) to @response.body" do
    response = DwollaV2::Response.new raw_response
    expect(response[:foo]).to eq raw_response.body[:foo]
  end

  it "forwards enumerable to @response.body" do
    response = DwollaV2::Response.new raw_response
    expect(response.select{true}).to eq raw_response.body.select{true}
  end

  it "forwards #==(obj) to @response.body" do
    response = DwollaV2::Response.new raw_response
    expect(response).to eq raw_response.body
  end
end
