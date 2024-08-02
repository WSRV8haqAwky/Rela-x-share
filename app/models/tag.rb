class Tag < ApplicationRecord

 has_many :post_relax_tags, dependent: :destroy
 has_many :post_relaxes, through: :post_relax_tags

 before_validation :downcase_name
 validates :name, presence: true, uniqueness: { case_sensitive: false }

 private

   def downcase_name
    self.name = name.downcase if name.present?
   end
end
