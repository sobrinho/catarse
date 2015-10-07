class AddRewardSurveyDetailsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      create view "1".reward_survey_details as
      	select
      		rs.id as id,
      		r.id as reward_id,
      		rs.options,
          rs.question
      	from
          reward_surveys rs
      	join rewards r on rs.reward_id = r.id
      	join projects p on p.id = r.project_id
      	where public.is_owner_or_admin(p.user_id);

      grant select on "1".reward_survey_details to web_user;
      grant select on "1".reward_survey_details to admin;
    SQL
  end

  def down
    execute <<-SQL
      drop view if exists "1".reward_survey_details;
    SQL
  end
end
