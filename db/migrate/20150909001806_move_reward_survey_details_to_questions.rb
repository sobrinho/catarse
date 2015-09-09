class MoveRewardSurveyDetailsToQuestions < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists "1".reward_survey_details;

      create view "1".reward_survey_questions as
      	select
      		rs.reward_id,
      		rs.id as id,
          rs.help_text,
      		rs.options,
          rs.question
      	from
          reward_surveys rs;

      grant select on "1".reward_survey_questions to anonymous;
      grant select, update, insert on "1".reward_survey_questions to web_user;
      grant select, update, insert on "1".reward_survey_questions to admin;

      create function public.reward_update_policy()
      RETURNS TRIGGER
      LANGUAGE plpgsql
      AS $$
      DECLARE
        project_owner int := (SELECT user_id FROM public.projects p JOIN public.rewards r ON r.project_id = p.id WHERE r.id = NEW.reward_id);
      BEGIN
        IF not public.is_owner_or_admin(project_owner) THEN
          RAISE EXCEPTION 'User % cannot update reward %', current_user, new.reward_id;
        END IF;
        RETURN new;
      END;
      $$;

      create trigger reward_update_policy before update or insert on public.reward_surveys for each row execute procedure public.reward_update_policy();
    SQL
  end

  def down
    execute <<-SQL
      drop function if exists public.reward_update_policy() cascade;
      drop view if exists "1".reward_survey_details;
      drop view if exists "1".reward_survey_questions;

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
end
