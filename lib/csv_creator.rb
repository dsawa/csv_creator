require 'csv_creator/version'
require 'csv_creator/creator'
require 'csv'
require 'active_support/core_ext/hash'
require 'pry'

module CsvCreator
  def self.create(collection, options = {})
    options_with_defaults = options.reverse_merge({
        csv: { force_quotes: true, headers: true },
        only: nil,
        without: nil,
        order: [],
        order_direction: :asc,
        translate: {},
        callbacks: {}
      })

    Creator.new(collection, options_with_defaults).generate_csv(options_with_defaults)
  end
end
