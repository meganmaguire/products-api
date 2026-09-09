require "spec_helper"

RSpec.describe Product do
  describe "#initialize" do
    let(:product) { Product.new(id: 1, name: "Cafe") }

    it "sets id" do
      expect(product.id).to eq(1)
    end

    it "sets name" do
      expect(product.name).to eq("Cafe")
    end
  end
end
