class AddActiveRecordSurveyNodeMapGroup < ActiveRecord::Migration
	def self.up
		create_table :active_record_survey_api_node_map_groups do |t|
			t.references :active_record_survey

			t.timestamps null: false
		end

		add_column :active_record_survey_node_maps, :active_record_survey_api_node_map_group_id, :integer
	end

	def self.down
		drop_table :active_record_survey_node_map_groups
		remove_column :active_record_survey_node_maps, :active_record_survey_api_node_map_group_id
	end
end