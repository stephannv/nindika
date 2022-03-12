# frozen_string_literal: true

RSpec::Matchers.define :not_talk_to_db do |_expected|
  match do |block_to_test|
    %i[exec_delete exec_insert exec_query exec_update].each do |meth|
      expect(ActiveRecord::Base.connection).not_to receive(meth)
    end
    block_to_test.call
  end
  supports_block_expectations
end
