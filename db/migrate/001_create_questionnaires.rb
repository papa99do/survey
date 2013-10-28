class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.column :title,        :string, :limit => 255
      t.column :description,  :text
      t.column :status,       :string, :limit => 20
    end
  end

  def self.down
    drop_table :questionnaires
  end
end
