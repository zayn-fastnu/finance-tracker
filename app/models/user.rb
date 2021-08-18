class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #validates :first_name, presence: true
  #validates :last_name, presence: true

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end
  
  def under_stock_limit?
    stocks.count<10
  end 

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
  
  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.params_allowed?(param)
    param[:q].values.reject(&:blank?).any?
  end

  def find_friends(param)
    @q = User.ransack(param[:q])
    friends =@q.result(distinct: true)
    unless friends.empty?
      friends = friends.reject { |user| user.id == id}
      return nil if friends.empty?
      return friends
    end
   nil
  end

  def not_friends_with?(id_of_friend)
    !friends.where(id: id_of_friend).exists?
  end 
end
