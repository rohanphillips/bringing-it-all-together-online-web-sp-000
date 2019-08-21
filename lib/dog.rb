class Dog
  attr_accessor :id, :name, :breed

  def initialize(info_hash)
  	info_hash.each{|key, value| self.send(("#{key}="), value)}
  end

  def self.create_table
    sql = <<-SQL

    SQL
  end

end
