class Expense < ActiveRecord::Base
  has_many :payments
  has_many :users, through: :payments
  belongs_to :owner, class_name: "User"
  belongs_to :house
  validates_length_of :title, :maximum => 60, :allow_blank => false 

  def split_amount
    num_users = users.size
    split = amount / num_users
    split.round(2)
  end

	def expense_text
    "You owe #{owner.first_name} $#{amount}. Due #{date_due.strftime("%B %d")}."
  end

  def text_sender
    users.each do |user|
      user.send_text_message(expense_text)
    end
  end

  def due_in_3days?
    Time.now
  end

  def auto_text
  end

end



