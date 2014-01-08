require 'spec_helper'

describe LightSide::Resources do
  let(:auth_token) { "abc123" }
  let(:base_url) { "https://api.example.com/api" }
  let(:prompts) { LightSide::Prompt.all }
  let(:prompt) { prompts.first }
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

  context ".all" do
    let(:response_body) { File.new("spec/fixtures/prompts.json") }

    before do
      stub_request(:get, "#{base_url}/prompts/?page=1").with(:headers => headers).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    it "gets the first page of prompts" do
      expect(prompts).to be_kind_of(LightSide::Pager)
      expect(prompts.count).to eq 2
      expect(prompt).to be_kind_of(LightSide::Prompt)
      expect(prompt.url).to eq "https://api.example.com/api/prompts/2"
    end
  end

  context ".page" do
    let(:response_body) { File.new("spec/fixtures/prompts.json") }

    before do
      stub_request(:get, "#{base_url}/prompts/?page=2").with(:headers => headers).
        to_return(:status => 200, :body => response_body, :headers => {})
    end

    context "when requesting without a page number" do
      let(:prompts) { LightSide::Prompt.page }
      it "raises an exception" do
        expect { prompts }.to raise_error
      end
    end

    context "when requesting with page number nil" do
      let(:prompts) { LightSide::Prompt.page(nil) }
      it "raises an exception" do
        expect { prompts }.to raise_error
      end
    end

    context "when requesting with page number 2" do
      let(:prompts) { LightSide::Prompt.page(2) }
      it "returns the second page of results" do
        expect(prompts.collection.map(&:class)).to eq [LightSide::Prompt]*2
      end
    end
  end

  context ".find" do
    context "with a valid ID" do
      let(:response_body) { File.new("spec/fixtures/prompts/2.json") }
      let(:prompt) { LightSide::Prompt.find(2) }

      before do
        stub_request(:get, "#{base_url}/prompts/2").
          with(:headers => headers).
          to_return(:status => 200, :body => response_body, :headers => {})
      end

      it "finds a prompt by its id" do
        expect(prompt).to be_kind_of(LightSide::Prompt)
        expect(prompt.url).to eq "https://api.example.com/api/prompts/2"
      end
    end

    context "with an invalid ID" do
      let(:prompt) { LightSide::Prompt.find(99) }

      before do
        stub_request(:get, "#{base_url}/prompts/99").with(:headers => headers).
          to_return(:status => 404, :body => "", :headers => {})
      end

      it "raises an exception" do
        expect { prompt }.to raise_error(LightSide::ResourceNotFound)
      end
    end
  end

  context ".create" do
    context "with valid input" do
      let(:response_body) { File.new("spec/fixtures/prompts/2.json") }
      let(:data) { JSON.generate({
        "title" => "new prompt title",
        "text" => "This is the text of the prompt.",
        "description" => "This prompt is an example.",
        "lower" => nil,
        "upper" => nil,
        "default_models" => [],
        "tags" => ["example", "period 2"]
      }) }

      before do
        headers.merge!('Content-Length' => data.length)
        stub_request(:post, "#{base_url}/prompts/").with(:headers => headers).
          to_return(:status => 201, :body => response_body, :headers => {})
      end

      it "creates a prompt" do
        prompt = LightSide::Prompt.create(data)
        expect(prompt.url).to eq "https://api.example.com/api/prompts/2"
      end
    end

    context "with invalid input" do
      let(:error_hash) { {"text"=>["This field is required."], "title"=>["This field is required."]} }
      let(:response_body) { JSON.generate(error_hash) }
      let(:data) { JSON.generate({}) }

      before do
        headers.merge!('Content-Length' => data.length)
        stub_request(:post, "#{base_url}/prompts/").with(:headers => headers).
          to_return(:status => 400, :body => response_body, :headers => {})
      end

      it "returns an unsaved prompt and populates its error hash" do
        prompt = LightSide::Prompt.create(data)
        expect(prompt.errors).to eq error_hash
      end
    end
  end

  context ".update" do
    context "with valid ID and input" do
      let(:response_body) { File.new("spec/fixtures/prompts/2.json") }
      let(:data) { JSON.generate({
        "title" => "new prompt title",
        "text" => "This is the text of the prompt.",
        "description" => "This prompt is an example.",
        "lower" => nil,
        "upper" => nil,
        "default_models" => [],
        "tags" => ["example", "period 2"]
      }) }

      before do
        headers.merge!('Content-Length' => data.length)
        stub_request(:put, "#{base_url}/prompts/2").with(:headers => headers).
          with(:body => data).
          to_return(:status => 200, :body => response_body, :headers => {})
      end

      it "updates the prompt" do
        prompt = LightSide::Prompt.update(2, data)
        expect(prompt.url).to eq "https://api.example.com/api/prompts/2"
      end
    end

    context "with valid ID and invalid input" do
      let(:error_hash) { {"text"=>["This field is required."], "title"=>["This field is required."]} }
      let(:response_body) { JSON.generate(error_hash) }
      let(:data) { JSON.generate({}) }

      before do
        headers.merge!('Content-Length' => data.length)
        stub_request(:put, "#{base_url}/prompts/2").with(:headers => headers).
          with(:body => data).
          to_return(:status => 400, :body => response_body, :headers => {})
      end

      it "return the prompt without updating and populates its error hash" do
        prompt = LightSide::Prompt.update(2, data)
        expect(prompt.errors).to eq error_hash
      end
    end

    context "with invalid ID" do
      let(:data) { JSON.generate({}) }
      let(:prompt) { LightSide::Prompt.update(99, data) }

      before do
        headers.merge!('Content-Length' => data.length)
        stub_request(:put, "#{base_url}/prompts/99").with(:headers => headers).
          with(:body => data).
          to_return(:status => 404, :body => "", :headers => {})
      end

      it "raises an exception" do
        expect { prompt }.to raise_error(LightSide::ResourceNotFound)
      end
    end
  end

  context ".delete" do
    context "with valid ID" do
      before do
        stub_request(:delete, "#{base_url}/prompts/2").with(:headers => headers).
          to_return(:status => 204, :body => "", :headers => {})
      end

      it "returns true" do
        expect(LightSide::Prompt.delete(2)).to eq true
      end
    end

    context "with invalid ID" do
      before do
        stub_request(:delete, "#{base_url}/prompts/99").with(:headers => headers).
          to_return(:status => 404, :body => "", :headers => {})
      end

      it "raises an exception" do
        expect { LightSide::Prompt.delete(99) }.to raise_error(LightSide::ResourceNotFound)
      end
    end
  end

end
