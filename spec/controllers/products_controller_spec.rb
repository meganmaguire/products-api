require "spec_helper"

RSpec.describe ProductsController do
  describe "#index" do
    subject(:response) { described_class.new(env).index }

    let(:env) { env_for("/products") }
    let(:status) { response[0] }
    let(:body) { response[2] }
    let(:parsed_body) { JSON.parse(body.first) }
    let(:expected_product_keys) { %w[id name]}

    it "authenticates the request" do
      response
      expect(warden).to have_received(:authenticate!)
    end

    it "returns a 200 status" do
      expect(status).to eq(200)
    end

    context "when there are no products" do
      it "returns an empty array" do
        expect(parsed_body).to eq([])
      end
    end

    context "when there are products" do
      before do
        ProductStore.save(Product.new(id: 1, name: "Cafe"))
        ProductStore.save(Product.new(id: 2, name: "Medialuna"))
      end

      it "returns every product, serialized" do
        expect(parsed_body.sample.keys).to contain_exactly(*expected_product_keys)
      end
    end
  end

  describe "#show" do
    let(:product_id) { "1" }
    let(:env) { env_for("/products/#{product_id}") }
    subject(:response) { described_class.new(env, "id" => product_id).show }
    let(:status) { response[0] }
    let(:body) { response[2] }
    let(:parsed_body) { JSON.parse(body.first) }
    let(:expected_product_keys) { %w[id name]}

    it "authenticates the request" do
      response
      expect(warden).to have_received(:authenticate!)
    end

    context "when the product does not exist" do
      let(:product_id) { "999" }

      it "returns a 404 status" do
        expect(status).to eq(404)
      end

      it "returns a not found error" do
        expect(parsed_body).to eq({ "error" => "Product not found" })
      end
    end

    context "when the product exists" do
      before { ProductStore.save(Product.new(id: 1, name: "Cafe")) }

      it "returns a 200 status" do
        expect(status).to eq(200)
      end

      it "returns the serialized product" do
        expect(parsed_body.keys).to contain_exactly(*expected_product_keys)
      end
    end
  end

  describe "#create" do
    let(:params) { { name: "Cafe" } }
    let(:env) { env_for("/products", method: "POST", params: params) }
    subject(:response) { described_class.new(env).create }
    let(:status) { response[0] }
    let(:body) { response[2] }
    let(:parsed_body) { JSON.parse(body.first) }

    it "authenticates the request" do
      response
      expect(warden).to have_received(:authenticate!)
    end

    context "when the name is missing" do
      let(:params) { {} }

      it "returns a 422 status" do
        expect(status).to eq(422)
      end

      it "returns a missing parameter error" do
        expect(parsed_body).to eq({ "error" => "Missing parameter: name" })
      end
    end

    context "when the name is blank" do
      let(:params) { { name: "   " } }

      it "returns a 422 status" do
        expect(status).to eq(422)
      end

      it "returns a missing parameter error" do
        expect(parsed_body).to eq({ "error" => "Missing parameter: name" })
      end
    end

    context "when the name is valid" do
      it "returns a 202 status" do
        expect(status).to eq(202)
      end

      it "returns the job url matching the job id" do
        expect(parsed_body["job_url"]).to eq("http://localhost:3000/jobs/#{parsed_body['job_id']}")
      end

      it "pushes the job id onto the job queue" do
        response
        expect(JobQueue.pop).to eq(parsed_body["job_id"])
      end

      context "the persisted job" do
        let(:job) { JobStore.find(parsed_body["job_id"]) }

        it "is a CreateProductWorker job" do
          expect(job.type).to eq(CreateProductWorker)
        end

        it "carries the given name as params" do
          expect(job.params).to eq({ name: "Cafe" })
        end

        it "starts out pending" do
          expect(job.status).to eq(:pending)
        end
      end
    end
  end
end
