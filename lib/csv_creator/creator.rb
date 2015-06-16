require 'csv'

module CsvCreator
  class Creator
    attr_reader :collection

    def initialize(collection, options)
      if options[:order].empty?
        @collection = collection
      else
        @collection = sort_collection(collection, options[:order], options[:order_direction])
      end
    end

    def generate_csv(options)
      CSV.generate(options[:csv]) do |csv|
        csv << csv_headers(options)
        csv_data(options).each { |data| csv << data }
      end
    end

    private

    def sort_collection(collection, fields, direction)
      coll = collection.sort_by { |el| fields.map { |field| el.send(field) } }
      direction.to_sym == :desc ? coll.reverse : coll
    end

    def csv_headers(options)
      set_headers(options)

      if options[:translate].empty?
        @headers
      else
        field_to_translate = options[:translate].keys
        @headers.map do |header|
          field_to_translate.include?(header) ? options[:translate][header] : header
        end
      end
    end

    def set_headers(options)
      headers = options[:only] ? options[:only].map { |field| field.to_sym } : get_attribute_names
      headers -= options[:without].map { |field| field.to_sym } if options[:without]

      @headers = headers
    end

    def get_attribute_names
      element = collection.first

      if element && element.respond_to?(:attribute_names)
        element.attribute_names.map { |attr| attr.to_sym }
      elsif element
        element.instance_variables.map { |v| v.to_s.gsub('@', '').to_sym }
      else
        []
      end
    end

    def csv_data(options)
      collection.map do |element|
        @headers.map do |header|
          if options[:callbacks] && options[:callbacks][header]
            options[:callbacks][header].yield element
          else
            element.send(header)
          end
        end
      end
    end
  end
end
