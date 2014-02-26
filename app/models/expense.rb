class Expense < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user_method }
  
  belongs_to :group
  
  belongs_to :payer, class_name: "User", foreign_key: "user_id"
  
  has_many :portions, dependent: :destroy

  validates :description, presence: true
  validates :amount, presence: true, numericality: {greater_than: 0}

  scope :settled, -> { where settled: true }
  scope :current, -> { where settled: false }

  after_create :generate_portions
  after_update :regenerate_portions

  def generate_portions
      sharing_users  = self.group.users
      portion_amount = self.amount / sharing_users.count
      sharing_users.each do |user|
        self.portions.create(expense_id: self.id, payee_id: user.id, amount: portion_amount)
      end
  end

  def regenerate_portions
    self.portions.destroy_all
    self.generate_portions
  end
  
end
