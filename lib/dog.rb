class Dog
  attr_accessor :id, :name, :breed

  def initialize(info_hash)
  	info_hash.each{|key, value| self.send(("#{key}="), value)}
  end

  def self.create(info_hash)
    new_dog = Dog.new(info_hash)
    new_dog.save
  end

  def self.new_from_db(row)
    new_student = Dog.new(self.create_info_hash(row))
  end

  def self.create_info_hash(array)
    hash = {}
    hash[:id] = array[0]
    hash[:name] = array[1]
    hash[:breed] = array[2]
    hash
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = #{id}
    SQL
    return_data = DB[:conn].execute(sql)
    new_dog = Dog.new(self.create_info_hash(return_data[0]))
    new_dog
  end

  def self.find_or_create_by(info)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = #{info[:name]} AND breed = #{info[:breed]}
    SQL
    return_data = DB[:conn].execute(sql)
    binding.pry
    new_dog = Dog.new(self.create_info_hash(return_data[0]))
    new_dog
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

end
