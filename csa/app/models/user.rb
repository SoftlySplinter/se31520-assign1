class User < ActiveRecord::Base
  attr_accessible :email, :firstname, :grad_year, :jobs, :phone, :surname
end
