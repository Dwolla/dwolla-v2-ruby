require "spec_helper"

describe DwollaV2::SuperHash do
  it "includes Hashie::Extensions::KeyConversion" do
    expect(DwollaV2::SuperHash.new).to be_a Hashie::Extensions::KeyConversion
  end

  it "includes Hashie::Extensions::MethodAccess" do
    expect(DwollaV2::SuperHash.new).to be_a Hashie::Extensions::MethodAccess
  end

  it "includes Hashie::Extensions::IndifferentAccess" do
    expect(DwollaV2::SuperHash.new).to be_a Hashie::Extensions::IndifferentAccess
  end

  it "includes Hashie::Extensions::DeepFetch" do
    expect(DwollaV2::SuperHash.new).to be_a Hashie::Extensions::DeepFetch
  end

  it "== works with non SuperHash values" do
    hash = { a: { b: { c: "d" } } }
    super_hash = DwollaV2::Util.deep_super_hasherize(hash)
    expect(super_hash).to eq hash
  end

  it "== works with nil values" do
    hash = { a: { b: { c: "d" } } }
    super_hash = DwollaV2::Util.deep_super_hasherize(hash)
    expect(super_hash).not_to eq nil
  end
end
