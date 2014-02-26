class Expense < ActiveRecord::Base
  include AASM

  belongs_to :group
  
  belongs_to :payer, class_name: "User", foreign_key: "user_id"
  
  has_many :portions, dependent: :destroy

  validates :description, presence: true
  validates :amount, presence: true, numericality: {greater_than: 0}

  scope :settled, { where settled: true }
  scope :current, { where settled: false }

  # manage the settled value with AASM 
  aasm :column => 'settled' do
    state :false, :initial => true
    state :true

    event :settle do
      transitions from: :false, to: :true
    end 
  end

end
