class Person
  attr_accessor :id, :name, :birth_date

  def initialize(attrs)
    @id = attrs[:id]
    @name = attrs[:name]
    @birth_date = attrs[:birth_date]
  end
end
