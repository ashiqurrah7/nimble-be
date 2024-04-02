class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :keyword
      t.string :adwords
      t.string :links
      t.string :results
      t.text :page_html

      t.timestamps
    end
  end
end
