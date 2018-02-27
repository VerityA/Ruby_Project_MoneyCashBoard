require_relative('models/merchants.rb')
require_relative('models/tags.rb')
require_relative('models/transactions.rb')
require_relative('models/budget.rb')
require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')

get '/my-money/budget/edit' do
  @tags = Tag.show_all
  @budget = Budget.show_all
  erb(:edit)
end

get '/my-money/transaction/:id/edit' do
  @tags = Tag.show_all
  @transcation = Transaction.find_by_id(params[:id].to_i)
  erb(:transaction_edit)
end

get '/my-money' do
  current_week = Date.today.cweek
  current_month = Date.today.month
  current_year = Date.today.year
  current_week_date = Date.commercial(current_year, current_week)
  next_week_date = Date.commercial(current_year, current_week + 1) - 1
  current_month_date = Date.new(current_year, current_month)
  next_month_date = Date.new(current_year, current_month + 1) - 1
  current_year_date = Date.new(current_year)
  next_year_date = Date.new(current_year + 1) - 1
  @transactions = Transaction.show_all()
  @tags = Tag.show_all()
  @merchants = Merchant.show_all()
  @cweek_total = Transaction.total_by_date(current_week_date, next_week_date)
  @cmonth_total = Transaction.total_by_date(current_month_date, next_month_date)
  @cyear_total = Transaction.total_by_date(current_year_date, next_year_date)
  @budget = Budget.show_all
  erb(:home)
end

get '/my-money/index' do
  @transactions = Transaction.show_all()
  @tags = Tag.show_all()
  erb(:index)
end

get '/my-money/:tag_id' do
  @tags = Tag.show_all()
  @transactions = Transaction.show_by_type(params[:tag_id])
  erb(:show)
end

get '/my-money/:month/show-month' do
  @tags = Tag.show_all()
  @transactions = Transaction.show_by_month(params[:month])
  erb(:dates)
end

post '/my-money' do
  merchant = Merchant.new(params)
  merchant.save()
  params['merchant_id'] = merchant.id
  transaction = Transaction.new(params)
  transaction.save()
  redirect to '/my-money'
end


post '/my-money/show/:id/delete' do
  Transaction.delete_by_id(params[:id])
  redirect to "/my-money/#{params[:tag_id]}"
end

post '/my-money/all/:id/delete' do
  Transaction.delete_by_id(params[:id])
  redirect to '/my-money/index'
end

post '/my-money/budget/:id' do
  budget = Budget.new(params)
  budget.update
  redirect to '/my-money'
end

post '/my-money/delete-all' do
  Transaction.delete_all()
  redirect to '/my-money'
end
