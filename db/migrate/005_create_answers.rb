class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :question_id,      :integer, :on_delete => :cascade
      t.column :answer_sheet_id,  :integer, :on_delete => :cascade
      t.column :selected_options, :string,  :limit => 100
      t.column :content,          :text
    end
  end

  def self.down
    drop_table :answers
  end
end
