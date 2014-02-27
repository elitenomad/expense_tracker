class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :portions, foreign_key: :payee_id

  has_many :expenses

  has_many :settlements

  has_many :mygroups, foreign_key: :owner_id, class_name: 'Group'
  
  has_and_belongs_to_many :groups
  
end
