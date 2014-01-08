require 'spec_helper'

describe LightSide::Config do
  let(:auth_token) { "abc123" }
  let(:base_url) { "https://api.example.com/api/" }

  it "can set auth_token" do
    LightSide.configure do |config|
      config.auth_token = auth_token
    end
    expect( LightSide::Config.auth_token ).to eq auth_token
  end

  it "can set base_url" do
    LightSide.configure do |config|
      config.base_url = base_url
    end
    expect( LightSide::Config.base_url ).to eq base_url
  end

  context ".configured?" do
    context "when auth_token is missing" do
      it "returns false" do
        LightSide::Config.auth_token = nil
        expect( LightSide::Config.configured? ).to be_false
      end
    end

    context "when base_url is missing" do
      it "returns false" do
        LightSide::Config.base_url = nil
        expect( LightSide::Config.configured? ).to be_false
      end
    end
  end
end
