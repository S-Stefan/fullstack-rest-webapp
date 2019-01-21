require "pg"

class Expense
  attr_accessor :id, :activity, :description, :cost, :date

  # There is a difference between class methods and instance methods.
  def self.open_connection
    return PG.connect dbname: "expense_db", user: "postgres", password: "password"
  end

  def self.all
    con = self.open_connection

    sql = "SELECT * FROM expense ORDER BY id;"

    results = con.exec sql
    # Go through each entry in the results array, hydrate it (put it into our desired format/model) then map each hydrated entry of the results array to a new array of post objects.
    expenses = results.map do |tuple|
      self.hydrate tuple
    end
    return expenses
  end

  def self.hydrate expense_data
    expense = Expense.new

    expense.id = expense_data["id"]
    expense.activity = expense_data["activity"]
    expense.description = expense_data["description"]
    expense.cost = expense_data["cost"]
    expense.date = expense_data["date"]

    return expense
  end

  # This method is used by SHOW.
  def self.find id
    # Open up a connection to the database.
    con = self.open_connection

    # Query db to get the post with 'id'.
    sql = "SELECT * FROM expense WHERE id = #{id};"

    # execute the sql in the db and store the result in result.
    result = con.exec sql # we do .first because .exec returns an array even though it's a single item, so we have an array of one item. We use sql[0] or .first for the Ruby way. Here we would have to do con.exec(sql).first

    # Hydrate the result.
    expense = self.hydrate result.first

    # return hydrated result.
    return expense
  end

  # This method will be used by CREATE and UPDATE.
  def save
    # Open a connection to the db.
    # We don't do self.open_connection because we need to call open_connection as a class method of the Post class, rather than an instance method of the class Post.
    con = Expense.open_connection

    # truthy falsey, as long as self.id has a value/exists then it will return something enabling it to be true.
    if !self.id #CREATE.
      # Define our Query/SQL.
      sql = "INSERT INTO expense(activity, description, cost, date) VALUES('#{self.activity}', '#{self.description}', '#{self.cost}', '#{self.date}');"
    else # UPDATE.
      sql = "UPDATE expense SET activity = '#{self.activity}', description = '#{self.description}', cost = #{self.cost}, date = '#{self.date}'
      WHERE id = #{self.id};"
    end

    # Run the sql.
    con.exec sql
  end

  # DELETE.
  def self.destroy id
    # Open a connection to the db.
    con = Expense.open_connection

    # sql query.
    sql = "DELETE FROM expense WHERE id = #{id};"

    # Run sql.
    con.exec sql
  end
end
