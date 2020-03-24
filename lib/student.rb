require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id =id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    if self.id
        self.update
    else
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      #@id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    end

  end

  def self.create(name:, grade:)
    binding.pry
    student = Student.new(name, grade)
    student.save
    student
  end

  def update
    sql = "UPDATE songs SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
