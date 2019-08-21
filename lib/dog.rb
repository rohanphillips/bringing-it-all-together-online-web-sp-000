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
    new_student = Dog.new(row[1], row[2], row[0])
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
