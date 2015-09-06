class AddRewardSurveyDetailsView < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop function if exists public.is_owner_or_admin(integer);
      CREATE FUNCTION public.is_owner_or_admin(user_id integer) RETURNS boolean
        LANGUAGE sql STABLE
        AS $_$
            SELECT
              (current_user = 'admin' OR current_setting('user_vars.user_id') = $1::text);
          $_$;

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
      drop function if exists public.is_owner_or_admin(integer);
      CREATE FUNCTION public.is_owner_or_admin(user_id integer) RETURNS boolean
        LANGUAGE sql STABLE SECURITY DEFINER
        AS $_$
            SELECT
              (current_user = 'admin' OR current_setting('user_vars.user_id') = $1::text);
          $_$;
    SQL
  end
end
