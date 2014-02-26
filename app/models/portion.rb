class Portion < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user_method }

  belongs_to :expense
  belongs_to :group

  belongs_to :payee, class_name: 'User'

  scope :settled, -> { where settled: true }
  scope :current, -> { where settled: false }


end
