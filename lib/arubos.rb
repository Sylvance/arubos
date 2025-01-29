# frozen_string_literal: true

require_relative "arubos/version"

module Arubos
  class Error < StandardError; end

  def self.run(name:)
    puts "Hello #{name}!"
    0
  end
end
