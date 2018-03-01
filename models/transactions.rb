require_relative('../db/sql_runner.rb')

class Transaction

  attr_accessor  :amount, :merchant_id, :tag_id, :trans_date
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_f
    @merchant_id = options['merchant_id'].to_i
    @tag_id = options['tag_id'].to_i
    @trans_date = options['trans_date']

  end

  def save()
    sql = "INSERT INTO transactions
    (
      amount,
      merchant_id,
      tag_id,
      trans_date
      )
    VALUES
    ($1, $2, $3, $4)
    RETURNING *;"
    values = [@amount, @merchant_id, @tag_id, @trans_date]
    transaction = SqlRunner.run(sql, values)
    @id = transaction[0]['id'].to_i
  end

  def update()
    sql = "UPDATE transactions
    SET
    (
      amount,
      merchant_id,
      tag_id,
      trans_date
      )
      =
      ($1, $2, $3, $4)
      WHERE id = $5;"
      values = [@amount, @merchant_id, @tag_id, @trans_date, @id]
      transaction = SqlRunner.run(sql, values)
  end

  def tag()
    sql = "SELECT * FROM tags
    WHERE id = $1;"
    tag = SqlRunner.run(sql, [@tag_id])
    return tag[0]['tag_name']
  end

  def merchant()
    sql = "SELECT * FROM merchants
    WHERE id = $1;"
    merchant = SqlRunner.run(sql, [@merchant_id])
    return merchant[0]['merchant_name']
  end

  def month()
    month = @trans_date.split("-")[1].to_i
    return month
  end

  def Transaction.delete_by_id(id)
    sql = "DELETE FROM transactions
    WHERE id = $1;"
    result = SqlRunner.run(sql, [id])
  end

  def Transaction.show_all()
    sql = "SELECT * FROM transactions
    ORDER BY trans_date DESC;"
    transactions = SqlRunner.run(sql)
    return transactions.map { |transaction| Transaction.new(transaction)  }
  end

  def Transaction.show_by_type(id)
    sql = "SELECT * FROM transactions
    WHERE tag_id = $1
    ORDER BY trans_date DESC;"
    transactions = SqlRunner.run(sql, [id])
    return transactions.map { |transaction| Transaction.new(transaction)  }
  end

  def Transaction.show_by_month(month)
    current_year = Date.today.year
    sql = "SELECT * FROM transactions
    WHERE trans_date BETWEEN $1 AND $2
    ORDER BY trans_date DESC;"
    values = [Date.new(current_year,month.to_i), (Date.new(current_year,month.to_i + 1) - 1)]
    transactions = SqlRunner.run(sql, values)
    return nil if transactions == nil
    return transactions.map { |transaction| Transaction.new(transaction) }
  end

  def Transaction.sum_by_transactions(transactions)
    amounts = transactions.map { |transaction| transaction.amount  }
    p amounts
    total_amount = amounts.inject {|sum, n| sum + n }
    p total_amount
    return '%.2f' % total_amount.to_f
  end

  def Transaction.delete_all()
    sql = "DELETE FROM transactions;"
    result = SqlRunner.run(sql)
  end

  def Transaction.total_by_date(start_date, end_date)
    sql = "SELECT SUM(amount) FROM transactions
    WHERE trans_date BETWEEN $1 AND $2;"
    values = [start_date.to_s, end_date.to_s]
    total = SqlRunner.run(sql, values)
    return '%.2f' % total[0]['sum'].to_f
  end

  def Transaction.show_by_date(start_date, end_date)
    sql = "SELECT * FROM transactions
    WHERE trans_date BETWEEN $1 AND $2
    ORDER BY trans_date DESC;"
    values = [start_date.to_s, end_date.to_s]
    transactions =SqlRunner.run(sql, values)
    return transactions.map { |transaction| Transaction.new(transaction) }
  end

  def Transaction.find_by_id(id)
    sql = "SELECT * FROM transactions
    WHERE id = $1;"
    result = SqlRunner.run(sql, [id.to_i])
    return nil if result.count == 0
    budget = Transaction.new(result[0])
    return budget
  end

end
