class CreatePostRelaxTags < ActiveRecord::Migration[5.2]
  def change
    create_table :post_relax_tags do |t|
      t.references :post_relax, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
