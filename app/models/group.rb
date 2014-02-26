class Group < ActiveRecord::Base
  include AASM
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
      transitions from: :settling, to: :open
    end

    event :close do
      transitions from: :open, to: :closed
    end
  end
end