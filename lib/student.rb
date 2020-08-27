require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    self.id = id
    self.name = name
    self.grade = grade
  end

def  self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
  sql = <<-SQL
  DROP TABLE students
  SQL

  DB[:conn].execute(sql)
end

def save
  if self.id == nil
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (? , ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  else
    self.update
  end
end

def self.create(name, grade)
  student = Student.new(name,grade).save
end

def self.new_from_db(array)
  Student.new(array[0],array[1],array[2])
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE name = ?
  SQL

  DB[:conn].execute(sql, name).map do |attr_array|
    Student.new_from_db(attr_array)
  end.first
end

def update
  sql = <<-SQL
  UPDATE students
  SET name = ?, grade = ?
  WHERE id = ?
  SQL

  DB[:conn].execute(sql, self.name, self.grade, self.id)
end

end
