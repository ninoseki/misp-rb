# frozen_string_literal: true

RSpec.shared_examples "delete example" do
  let(:subject) { described_class }

  describe "#delete" do
    let(:new_one) { subject.create(**attributes) }

    it do
      res = new_one.delete
      expect(res).to be_a(Hash)
    end
  end

  describe ".delete" do
    let(:new_one) { subject.create(**attributes) }

    it do
      res = subject.delete(new_one.id)
      expect(res).to be_a(Hash)
    end
  end
end
