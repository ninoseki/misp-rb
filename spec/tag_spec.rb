# frozen_string_literal: true

RSpec.describe MISP::Tag, :vcr do
  let(:attributes) {
    { name: "test:created" }
  }

  include_examples "create example"
  include_examples "delete example"
  include_examples "get example"
  include_examples "update example"
end
