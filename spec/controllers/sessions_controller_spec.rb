require "spec_helper"

RSpec.describe SessionsController do
  describe "#create" do
    let(:params) { { username: "usuario", password: "12345678" } }
    let(:env) { env_for("/sessions", method: "POST", params: params) }
    subject(:response) { described_class.new(env).create }
    let(:status) { response[0] }
    let(:headers) { response[1] }
    let(:body) { response[2] }
    let(:parsed_body) { JSON.parse(body.first) }

    it "resets any existing session before authenticating" do
      response

      expect(warden).to have_received(:reset_session!).ordered
      expect(warden).to have_received(:authenticate!).ordered
    end

    it "returns a 200 status" do
      expect(status).to eq(200)
    end

    it "returns a JSON content-type header" do
      expect(headers).to eq({ "content-type" => "application/json" })
    end

    it "returns a success message" do
      expect(parsed_body).to eq({ "message" => "Successful log in" })
    end
  end
end
