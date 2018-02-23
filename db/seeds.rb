require_relative('../models/merchants')
require_relative('../models/tags')
require_relative('../models/transactions')
require('pry-byebug')

Transaction.delete_all()
Tag.delete_all()
Merchant.delete_all()


merchant1 = Merchant.new({"merchant_name" => "Tesco"})
merchant2 = Merchant.new({"merchant_name" => "H+M"})
merchant3 = Merchant.new({"merchant_name" => "Pizza Express"})
merchant4 = Merchant.new({"merchant_name" => "Holland and Barrett"})

merchant1.save()
merchant2.save()
merchant3.save()
merchant4.save()

tag1 = Tag.new({"tag_name" => "Food"})
tag2 = Tag.new({"tag_name" => "Eating Out"})
tag3 = Tag.new({"tag_name" => "Clothes"})

tag1.save()
tag2.save()
tag3.save()

transaction1 = Transaction.new({"amount" => 34.50, "merchant_id" => merchant3.id(), "tag_id" => tag2.id()})
transaction2 = Transaction.new({"amount" => 7.95, "merchant_id" => merchant4.id(), "tag_id" => tag1.id()})
transaction3 = Transaction.new({"amount" => 60.20, "merchant_id" => merchant2.id(), "tag_id" => tag3.id()})
transaction4 = Transaction.new({"amount" => 12.79, "merchant_id" => merchant1.id(), "tag_id" => tag1.id()})


transaction1.save()
transaction2.save()
transaction3.save()
transaction4.save()


binding.pry

nil
