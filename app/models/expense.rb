class Expense < ActiveRecord::Base
  belongs_to :group
  
  belongs_to :payer, class_name: "User", foreign_key: "user_id"
  
  has_many :portions, dependent: :destroy
end
