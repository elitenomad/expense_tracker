class Portion < ActiveRecord::Base
  include AASM


  belongs_to :expense
  belongs_to :group

  belongs_to :payee, class_name: 'User'

  scope :settled, -> { where settled: true }
  scope :current, -> { where settled: false }

  # manage the settled value with AASM 
  aasm :column => 'settled' do
    state :false, :initial => true
    state :true

    event :settle do
      transitions from: :false, to: :true
    end 
  end


end
