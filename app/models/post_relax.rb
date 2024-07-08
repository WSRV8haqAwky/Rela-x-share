class PostRelax < ApplicationRecord
  belongs_to :user
  attachment :image
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :caption, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @post_relax = PostRelax.where("caption LIKE?","#{word}")
    elsif search == "forward_match"
      @post_relax = PostRelax.where("caption LIKE?","#{word}%")
    elsif search == "backward_match"
      @post_relax = PostRelax.where("caption LIKE?","%#{word}")
    elsif search == "partial_match"
      @post_relax = PostRelax.where("caption LIKE?","%#{word}%")
    else
      @post_relax = PostRelax.all
    end
  end
end
