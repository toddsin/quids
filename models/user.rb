require_relative '../db/sql_runner.rb'

class User
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name'].gsub(/\b\w/, &:capitalize)
    @picture = options['picture']
  end

  def to_s
    "ID: #{@id}, Name: #{@name} and Picture URL: #{@picture}."
  end

  def save
    sql = 'INSERT INTO users (name, picture) VALUES ($1, $2) RETURNING id;'
    values = [@name, @picture]
    @id = SQL.run(sql, values)[0]['id'].to_i
  end

  def update
    sql = 'UPDATE users SET (name, picture) = ($1, $2) WHERE id = $3;'
    values = [@name, @picture, @id]
    SQL.run(sql.values)
  end

  def delete
    SQL.run('DELETE FROM users WHERE id = $1;', [@id])
  end

  def self.delete_all
    SQL.run('DELETE FROM users;', [])
  end

  def self.find_all
    SQL.run('SELECT * FROM users;', []).map do |user_hash|
      User.new(user_hash)
    end
  end

  def self.find(id)
    User.new(SQL.run('SELECT * FROM users WHERE id = $1;', [id])[0])
  end
end
