require 'spec_helper'

describe LightSide::Pager do
  let(:auth_token) { "abc123" }
  let(:base_url) { "https://api.example.com/api" }
  let(:headers) { {
    "Accept"        => "*/*; q=0.5, application/xml",
    "Accept-Encoding" => "gzip, deflate",
    "Authorization" => "Token #{auth_token}",
    "Content-Type"  => "application/json",
    "User-Agent"    => "Ruby"
  } }

  before do
    LightSide.configure do |config|
      config.auth_token = auth_token
      config.base_url = base_url
    end
  end

  context "when url is not supplied" do
    let(:page_url) { "https://api.example.com/api/prompts/?page=1" }
    let(:pager) { LightSide::Pager.new(LightSide::Prompt) }

    it "starts at page 1" do
      expect(pager.page_number).to eq 1
      expect(pager.resource_path).to eq page_url
    end
  end

  context "when retrieving by page number" do
    let(:path) { "https://api.example.com/api/prompts/" }
    let(:pager) { LightSide::Pager.new(LightSide::Prompt, params) }

    context "without query params" do
      let(:params) { {page: 2} }
      let(:response_body) { File.new("spec/fixtures/prompts_2.json") }

      before do
        stub_request(:get, "#{base_url}/prompts/?page=2").with(:headers => headers).
          to_return(:status => 200, :body => response_body, :headers => {})
      end

      it "starts at page 2" do
        expect(pager.page_number).to eq 2
      end

      it "sets the next url" do
        pager.fetch
        expect(pager.next_url).to eq "#{base_url}/prompts/?page=2"
        expect(pager.collection.map(&:class)).to eq [LightSide::Prompt]*2
      end
    end

    context "with query params" do
      let(:params) { {page: 2, all: true} }
      let(:response_body) { File.new("spec/fixtures/prompts_4.json") }

      before do
        stub_request(:get, "#{base_url}/prompts/?page=2&all=true").with(:headers => headers).
          to_return(:status => 200, :body => response_body, :headers => {})
      end

      it "starts at page 2" do
        expect(pager.page_number).to eq 2
      end

      it "sets the next url" do
        pager.fetch
        expect(pager.next_url).to eq "#{base_url}/prompts/?page=2&all=true"
        expect(pager.collection.map(&:class)).to eq [LightSide::Prompt]*2
      end
    end

    context "#next" do
      let(:params) { {page: 2} }
      let(:response_body) { File.new("spec/fixtures/prompts_2.json") }

      context "when next_url is missing" do
        it "raises an exception" do
          expect(pager.page_number).to eq 2
          expect(pager.next_url).to be_nil
          expect { pager.next }.to raise_error("no more results")
        end
      end

      context "when next_url is present" do
        let(:response_body_2) { File.new("spec/fixtures/prompts_3.json") }
        let(:page_3_url) { "#{base_url}/prompts/?page=3" }

        before do
          stub_request(:get, "#{base_url}/prompts/?page=3").with(:headers => headers).
            to_return(:status => 200, :body => response_body_2, :headers => {})
        end

        it "fetches the next set of results" do
          pager.next_url = page_3_url
          pager.next
          expect(pager.collection).not_to be_empty
        end
      end
    end
  end
end
