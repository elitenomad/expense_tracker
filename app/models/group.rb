class Group < ActiveRecord::Base
  include PublicActivity::Common
  #tracked owner: ->(controller, model) { controller && controller.current_user_method }

  include AASM


  belongs_to :owner, class_name: 'User'
  
  has_and_belongs_to_many :users

  has_many :settlements

  has_many :expenses

  has_many :portions, through: :expenses

  validates :name, presence: true

  # manage the status with AASM 
  aasm :column => 'status' do
    state :open, :initial => true
    state :settling
    state :closed

    event :settle do
      after do 
        self.save
        generate_settlements
      end
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


  def do_settlement=(val)
    if val == "true"
      self.settle
    end
  end

  def settle_all_expenses
    self.expenses.current.each do |expense|
      expense.update_attribute(:settled, true)
    end
  end
  
  def settle_all_portions
    self.portions.current.each do |portion|
      portion.update_attribute(:settled, true)
    end
  end
  
  def all_group_settlements_confirmed?
    # if thereis at least 1 false, the function return false, otherwise return true
    check = true
    self.settlements.each do |settlement| 
      if settlement.confirm == false
       check = false
      end
    end
    check
  end

  def generate_settlements
  # for first user in hash compare the balance with first user in 2nd hash
  # if 1st > 2nd
  # update 1st user balanceu
  # update 2nd user balance and store 2nd user owes 1st user
  # you need to go to 3rd user
    owed, owes = generate_owes_and_owed_balance
    settle_at = Time.now.utc    
    # compare balances between owed and owes
    # update balances and create settlements
    owes.each do |user2, owes_balance|
      abs_owes_balance = owes_balance.abs
      # for each user in hash who is owed money take money from users who owe money until balance is even
      # then delete owed user and take next owed user and iterate
      begin
        user,owed_balance = owed.first
        # if user who is owed has a lower balance, they can be paid in full
        if owed_balance == 0                        
          owed.delete(user)
          
        elsif abs_owes_balance >= owed_balance   
          abs_owes_balance = abs_owes_balance - owed_balance          
          # create settlement, 
          
          Settlement.create(owed_id: user.id, owes_id: user2.id, payment: owed_balance, group_id: self.id, confirm: false, settle_at: settle_at )
           owed.delete(user)
          
        else 
          owed_balance = owed_balance - abs_owes_balance     
          
          Settlement.create(owed_id: user.id, owes_id: user2.id, payment: abs_owes_balance, group_id: self.id, confirm: false, settle_at: settle_at)
          owed[user] = owed_balance
          abs_owes_balance = 0
        end
        
      end while owed.count != 0 && abs_owes_balance > 0
    end
  end


  def generate_owes_and_owed_balance
    exp = 0
    port = 0
    owed = {}
    owes = {}
    # calculate the balance of each user
    # this will need to be refactored when balance is added to the group table
    self.users.each do |user|
      
      expenses = self.expenses.current.where(user_id: user)
      expenses.each { |e| exp = exp + e.amount }
      portions = self.portions.current.where(payee_id: user)
      portions.each { |p| port = port + p.amount }
      if exp > port
        owed[user] = (exp - port).round(2)
      elsif exp < port
        owes[user] = (port - exp).round(2)
      end
      exp = 0
      port = 0   
    end
    return owed, owes
  end
end