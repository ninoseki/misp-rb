# frozen_string_literal: true

RSpec.describe MISP::Galaxy, :vcr do
  subject { described_class }

  include_examples "list example"

  describe ".get" do
    let(:id) { 1 }

    it do
      res = subject.get(id)
      expect(res).to be_a(described_class)
    end
  end
end
