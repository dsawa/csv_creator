require 'test_helper'

describe CsvCreator do
  before do
    @persons = (1..3).to_a.map do |index|
      Person.new(id: index, name: "person_name_#{index}", birth_date: DateTime.new(1990, 2, index))
    end
  end

  describe 'when generating CSV from collection with objects' do
    it 'should return CSV as String' do
      CsvCreator.create([]).must_be_instance_of String
      CsvCreator.create(@persons).must_be_instance_of String
    end

    it 'should put header on first CSV row' do
      expected_headers = %w(id name birth_date)

      csv_headers = CsvCreator.create(@persons).lines.first.gsub(/\"|\s/, '').split(',')
      csv_headers.sort.must_equal expected_headers.sort
    end

    it 'should return CSV based on given collection data' do
      csv_lines = CsvCreator.create(@persons).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

      csv_lines.size.must_equal 4
      csv_lines[0].must_equal %w(id name birth_date)
      csv_lines[1].must_equal %w(1 person_name_1 1990-02-01T00:00:00+00:00)
      csv_lines[2].must_equal %w(2 person_name_2 1990-02-02T00:00:00+00:00)
      csv_lines[3].must_equal %w(3 person_name_3 1990-02-03T00:00:00+00:00)
    end

    describe 'when using order option' do
      it 'should return CSV with data ordered by single field ASC' do
        reversed_persons = @persons.reverse
        options = { order: [:id], order_direction: :asc }

        csv_lines = CsvCreator.create(reversed_persons, options).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(id name birth_date)
        csv_lines[1].must_equal %w(1 person_name_1 1990-02-01T00:00:00+00:00)
        csv_lines[2].must_equal %w(2 person_name_2 1990-02-02T00:00:00+00:00)
        csv_lines[3].must_equal %w(3 person_name_3 1990-02-03T00:00:00+00:00)
      end

      it 'should return CSV with data ordered by single field DESC' do
        options = { order: [:name], order_direction: :desc }

        csv_lines = CsvCreator.create(@persons, options).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(id name birth_date)
        csv_lines[1].must_equal %w(3 person_name_3 1990-02-03T00:00:00+00:00)
        csv_lines[2].must_equal %w(2 person_name_2 1990-02-02T00:00:00+00:00)
        csv_lines[3].must_equal %w(1 person_name_1 1990-02-01T00:00:00+00:00)
      end

      it 'should return CSV with data ordered by multiple fields ASC' do
        reversed_persons = @persons.reverse
        options = { order: [:name, :id], order_direction: :asc }

        csv_lines = CsvCreator.create(reversed_persons, options).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(id name birth_date)
        csv_lines[1].must_equal %w(1 person_name_1 1990-02-01T00:00:00+00:00)
        csv_lines[2].must_equal %w(2 person_name_2 1990-02-02T00:00:00+00:00)
        csv_lines[3].must_equal %w(3 person_name_3 1990-02-03T00:00:00+00:00)
      end

      it 'should return CSV with data ordered by multiple fields DESC' do
        reversed_persons = @persons.reverse
        options = { order: [:name, :id], order_direction: :desc }

        csv_lines = CsvCreator.create(reversed_persons, options).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(id name birth_date)
        csv_lines[1].must_equal %w(3 person_name_3 1990-02-03T00:00:00+00:00)
        csv_lines[2].must_equal %w(2 person_name_2 1990-02-02T00:00:00+00:00)
        csv_lines[3].must_equal %w(1 person_name_1 1990-02-01T00:00:00+00:00)
      end
    end

    describe 'when using only option' do
      it 'should return CSV with only fields that are passed in only option' do
        csv_lines = CsvCreator.create(@persons, { only: [:name] }).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(name)
        csv_lines[1].must_equal %w(person_name_1)
        csv_lines[2].must_equal %w(person_name_2)
        csv_lines[3].must_equal %w(person_name_3)
      end
    end

    describe 'when using without option' do
      it 'should return CSV data without the ones given in without option' do
        csv_lines = CsvCreator.create(@persons, { without: [:birth_date, :id] }).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }

        csv_lines.size.must_equal 4
        csv_lines[0].must_equal %w(name)
        csv_lines[1].must_equal %w(person_name_1)
        csv_lines[2].must_equal %w(person_name_2)
        csv_lines[3].must_equal %w(person_name_3)
      end
    end

    describe 'when using translate option' do
      it 'should translate desired headers as specified' do
        options = { translate: { id: 'person_id', name: 'person_name', birth_date: 'date_of_birth' } }

        csv_headers = CsvCreator.create(@persons, options).lines.first.gsub(/\"|\s/, '').split(',')
        csv_headers.must_equal %w(person_id person_name date_of_birth)
      end
    end

    describe 'when using callbacks option' do
      it 'should run callback on a field specified in options and return value based on it' do
        options = { callbacks: { birth_date: ->(person) { person.birth_date.strftime('%m/%d/%Y') } } }

        csv_lines = CsvCreator.create(@persons, options).lines.map { |line| line.gsub(/\"|\s/, '').split(',') }
        csv_lines[0].must_equal %w(id name birth_date)
        csv_lines[1].must_equal %w(1 person_name_1 02/01/1990)
        csv_lines[2].must_equal %w(2 person_name_2 02/02/1990)
        csv_lines[3].must_equal %w(3 person_name_3 02/03/1990)
      end
    end

    describe 'when using csv option' do
      it 'should run apply options from csv key and apply them to define how CSV should be returned' do
        options = { csv: { force_quotes: false } }

        csv_lines = CsvCreator.create(@persons, options).lines

        csv_lines[0].must_equal "id,name,birth_date\n"
        csv_lines[1].must_equal "1,person_name_1,1990-02-01T00:00:00+00:00\n"
        csv_lines[2].must_equal "2,person_name_2,1990-02-02T00:00:00+00:00\n"
        csv_lines[3].must_equal "3,person_name_3,1990-02-03T00:00:00+00:00\n"
      end
    end
  end
end
