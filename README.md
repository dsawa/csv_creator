# CsvCreator

CsvCreator provides nice, configurable interface which will generate CSV file for you, from collection you want (database or array with non-db related objects).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csv_creator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_creator

## Usage

Basic usage with default options (see below) is just by calling `create` method on `CsvCreator` module.
There is also an alias method `generate`. It does the same thing and takes the same arguments.

```ruby
CsvCreator.create(my_collection)
```

### Options

Options can be passed as second argument to the `create` method. The default options hash looks like this.
```ruby
{
  csv: { force_quotes: true, headers: true },
  only: nil,
  without: nil,
  order: [],
  order_direction: :asc,
  translate: {},
  callbacks: {}
}
```

### Options explanation

* **csv** - In `csv` key you can pass all options that you would usually pass to the `CSV.generate`. 
Yoo can find more about them under [this link](http://ruby-doc.org/stdlib-2.2.2/libdoc/csv/rdoc/CSV.html). Look for "DEFAULT_OPTIONS".
```ruby
CsvCreator.create(my_collection, { csv: { force_quotes: false } })
```

* **only** - It's self explanatory. By passing an array of field names you will get in your CSV data only for that fields.
```ruby
CsvCreator.create(my_collection, { only: [:id, :name] })
```

* **without** - Like above, but this time, fields that are in the array passed under this key will be skipped during generation process.
```ruby
CsvCreator.create(my_collection, { without: [:id, :name] })
```

* **order** - Makes sense only for collections that are not from database. Obviously it's way better to sort collection with use of database queries. But if you want, `CsvCreator` can sort given collection for you. Under the hood there is simple [sort_by](http://ruby-doc.org/core-2.2.2/Enumerable.html#method-i-sort_by) method.
```ruby
CsvCreator.create(my_collection, { order: [:name] })
```

* **order_direction** - If you defined some fields that you want to order by your collection, you can manipulate direction.
```ruby
CsvCreator.create(my_collection, { order: [:name], order_direction: :desc })
```

* **translate** - Useful if you want to somehow change how the column header will be displayed in the CSV document. Very useful for language translations.
```ruby
CsvCreator.create(my_collection, { translate: { name: 'Translated Name Field' })
```

* **callbacks** - Callbacks can help you with modifying result for each row exactly for the CSV document. For example by formatting date time field or some other calculations.
```ruby
options = { callbacks: { birth_date: ->(person) { person.birth_date.strftime('%m/%d/%Y') } } }
CsvCreator.create(my_collection, options)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dsawa/csv_creator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

