class CreateRewardSurveys < ActiveRecord::Migration
  def up
    create_table :reward_surveys do |t|
      t.references :reward, index: true
      t.text :options, array: true, default: []
      t.text :question, null: false

      t.timestamps
    end

    add_index  :reward_surveys, :options, using: :gin
  end

  def down
    drop_table :reward_surveys
  end
end
