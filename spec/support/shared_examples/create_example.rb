# frozen_string_literal: true

RSpec.shared_examples "create example" do
  let(:subject) { described_class }

  describe ".create" do
    it do
      res = subject.create(**attributes)
      expect(res).to be_a(described_class)
    end
  end
end
