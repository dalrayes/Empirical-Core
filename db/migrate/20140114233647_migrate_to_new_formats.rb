class MigrateToNewFormats < ActiveRecord::Migration
  def change
    create_table :activity_classifications, force: true do |t|
      t.string :name
      t.string :key, null: false
      t.index :key, unique: true

      t.timestamps
    end

    create_table :activities, force: true do |t|
      t.hstore :data
      t.belongs_to :activity_classification
      t.belongs_to :topic

      t.timestamps
    end

    create_table :topics, force: true do |t|
      t.string :name
      t.belongs_to :section

      t.timestamps
    end

    create_table :classroom_activities, force: true do |t|
      t.belongs_to :classroom
      t.belongs_to :activity
      t.datetime :due_date
      t.boolean :temporary

      t.timestamps
    end

    create_table :activity_enrollments, force: true do |t|
      t.belongs_to :classroom_activity
      t.belongs_to :user

      t.string :pairing_id
      t.float :percentage
      t.string :state, default: 'unstarted', null: false
      t.integer :time_spent
      t.timestamp :completed_at

      t.hstore :data
      t.index :pairing_id, unique: true
    end

    remove_column :scores, :practice_step_input, :text
    remove_column :scores, :review_step_input, :text
    remove_column :scores, :items_missed, :integer
    remove_column :scores, :lessons_completed, :integer
    remove_column :scores, :score_values, :text

    rename_table :chapter_levels, :sections

    change_table :sections do |t|
      t.belongs_to :workbook
    end

    change_table :rule_question_inputs do |t|
      t.belongs_to :activity_enrollment
    end
  end
end
