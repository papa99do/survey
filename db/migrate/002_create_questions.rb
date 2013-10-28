class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.column :questionnaire_id, :integer, :on_delete => :cascade
      t.column :option_type,      :string,  :limit => 5
      t.column :answer_size,      :string,  :limit => 1
      t.column :show_as_stat,     :boolean, :default => true
      t.column :content,          :text
      t.column :order,            :integer
    end
  end

  def self.down
    drop_table :questions
  end
end
