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

  def self.liked_posts(user, page,per_page)
    includes(:favorites)
    .where(favorites: { user_id: user.id })
    .order(created_at: :desc)
    .page(page)
    .per(per_page)
  end

  scope :latest, -> { order(created_at: :desc) }  #desc = 降順
  scope :old, -> { order(created_at: :asc) }  #asc = 昇順
  scope :order_by_favorite_count, -> do
  sql = <<~SQL
    LEFT OUTER JOIN (
      SELECT f.post_relax_id, COUNT(*) AS cnt
      FROM favorites f
      GROUP BY f.post_relax_id
    ) favorite_counts
    ON favorite_counts.post_relax_id = post_relaxes.id
  SQL
  joins(sql)
    .order(Arel.sql("COALESCE(favorite_counts.cnt, 0) DESC")) # ④
end
 scope :reverse_order_by_favorite_count, -> do
  sql = <<~SQL
    LEFT OUTER JOIN (
      SELECT f.post_relax_id, COUNT(*) AS cnt
      FROM favorites f
      GROUP BY f.post_relax_id
    ) favorite_counts
    ON favorite_counts.post_relax_id = post_relaxes.id
  SQL
  joins(sql)
    .order(Arel.sql("COALESCE(favorite_counts.cnt, 0) ")) # ④
end
end
