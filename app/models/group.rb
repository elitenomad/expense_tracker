class Group < ActiveRecord::Base
  include PublicActivity::Common
  #tracked owner: ->(controller, model) { controller && controller.current_user_method }

  include AASM
  include ExpensesHelper

  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users


  has_many :expenses

  has_many :portions, through: :expenses

  validates :name, presence: true

  # manage the status with AASM 
  aasm :column => 'status' do
    state :open, :initial => true
    state :settling
    state :closed

    event :settle do
      transitions from: :open, to: :settling
    end 

    event :open do
      after do
        settle_all_expenses
        settle_all_portions
      end
      transitions from: :settling, to: :open
    end

    event :close do
      transitions from: :open, to: :closed
    end
  end


  def settle_all_expenses
    binding.pry
    self.expenses.current.each do |expense|
      expense.update_attribute(:settled, true)
    end
  end
  def settle_all_portions
    self.portions.current.each do |portion|
      portion.update_attribute(:settled, true)
    end
  end

end