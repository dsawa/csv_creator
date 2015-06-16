require 'csv_creator/version'
require 'csv_creator/creator'
require 'active_support/core_ext/hash'

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

  # Alias
  def self.generate(collection, options = {})
    create(collection, options)
  end
end
