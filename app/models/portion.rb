class Portion < ActiveRecord::Base
  include AASM

  belongs_to :expense

  belongs_to :payee, class_name: 'User'


  # manage the settled value with AASM 
  aasm :column => 'settled' do
    state :false, :initial => true
    state :true

    event :settle do
      transitions from: :false, to: :true
    end 
  end

end
