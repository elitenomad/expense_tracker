class Portion < ActiveRecord::Base


  belongs_to :expense
  belongs_to :group

  belongs_to :payee, class_name: 'User'

  scope :settled, -> { where settled: true }
  scope :current, -> { where settled: false }


end
