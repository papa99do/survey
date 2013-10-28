class CreateAnswerSheets < ActiveRecord::Migration
  def self.up
    create_table :answer_sheets do |t|
      t.column :questionnaire_id,     :integer, :on_delete => :cascade
      t.column :identifier,           :string, :limit => 100
      t.column :remote_ip,            :string, :limit => 50
    end
  end

  def self.down
    drop_table :answer_sheets
  end
end
