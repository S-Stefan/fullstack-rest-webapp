# These colons indicate that Sinatra is a module. A module is a collection of other classes.
# In java it would be Sinatra.Base
# We are using the Base class within the Sinatra module.
class ExpensesController < Sinatra::Base

  # This allows us to the reloader class only when you're in the development environment.
  configure :development do
    register Sinatra::Reloader
  end

  # This is to trick erb to look for views file one above, since it looks for views nested within the current directory by default.
  # sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  # 7 restful routes:
  # INDEX
  get "/" do
    # @expenses is an instance variable. This is what ruby secretly does with attr_accessor to define the properties in our classes.
    @expenses = Expense.all # .all is a method of the Expense class.
    # we are calling the erb function and passing it an argument, the relative filepath we want it to render.
    erb :"expenses/index.html"
  end

  # NEW
  get "/new" do
    @expense = Expense.new
    erb :"expenses/new.html"
  end

  # SHOW
  get "/:id" do
    # params is a hash where you pass information when you hit enter to load a page. :id is the key we want.
    id = params[:id].to_i
    @expense = Expense.find id
    erb :"expenses/show.html"
  end

  # EDIT
  get "/:id/edit" do
    id = params[:id].to_i
    @expense = Expense.find id
    erb :"expenses/edit.html"
  end

  # CREATE
  post "/" do
    # New instance of post.
    expense = Expense.new

    # explicity set title and body of post using the values from params.
    expense.activity = params[:activity]
    expense.description = params[:description]
    expense.cost = params[:cost]
    expense.date = params[:date]


    # This method will sort out and push our data to the db.
    expense.save

    redirect "/"

  end

  # UPDATE
  put "/:id" do
    # Find the Post we want to update.
    id = params[:id].to_i
    expense = Expense.find id

    # update it's fields.
    expense.activity = params[:activity]
    expense.description = params[:description]
    expense.cost = params[:cost]
    expense.date = params[:date]

    # save changes.
    expense.save

    redirect "/#{id}"
  end

  # DESTROY
  delete "/:id" do
    id = params[:id].to_i

    Expense.destroy id

    redirect "/"
  end
end
