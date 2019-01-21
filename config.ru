# config.ru is our rack
# rack will act as our router, because sinatra can only do one controller at a time.

require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader" if development?
require_relative "controllers/expenses_controller.rb" # require the code from the relative path.
require_relative "models/expense.rb" # require the code from the expense.rb file.

use Rack::MethodOverride
run ExpensesController
