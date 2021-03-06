class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    DB[:conn].execute(sql, 9).map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < ?
    SQL
    DB[:conn].execute(sql, 12).map {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students LIMIT ?
    SQL
    DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ? LIMIT ?
    SQL
    self.new_from_db(DB[:conn].execute(sql, 10, 1)[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name == ?
    SQL
    self.new_from_db(DB[:conn].execute(sql, name).first)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    
    DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

