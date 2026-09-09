require "spec_helper"

RSpec.describe User do
  let(:password_digest) { BCrypt::Password.create("s3cret") }
  let(:user) { User.new(id: 1, username: "usuario", password_digest: password_digest) }

  describe "#initialize" do
    it "sets id" do
      expect(user.id).to eq(1)
    end

    it "sets username" do
      expect(user.username).to eq("usuario")
    end

    it "sets password_digest" do
      expect(user.password_digest.to_s).to eq(password_digest.to_s)
    end
  end

  describe "#authenticate" do
    it "returns true when the password matches the stored digest" do
      expect(user.authenticate("s3cret")).to eq(true)
    end

    it "returns false when the password does not match" do
      expect(user.authenticate("wrong-password")).to eq(false)
    end
  end
end
