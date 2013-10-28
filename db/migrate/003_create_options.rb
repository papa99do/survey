class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.column :question_id,    :integer, :on_delete => :cascade
      t.column :content,        :text
      t.column :order,          :integer
    end
  end

  def self.down
    drop_table :options
  end
end
