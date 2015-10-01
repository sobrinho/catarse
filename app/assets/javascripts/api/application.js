//= require mithril
//= require underscore
//= require mithril.postgrest
//= require moment
//= require replace-diacritics
//= require chartjs
//= require api/init
//= require catarse.js/dist/catarse.js
//= require_self

(function(m, c, Chart){
  //Chart.defaults.global.responsive = true;
  Chart.defaults.global.responsive = false;
  Chart.defaults.Line.pointHitDetectionRadius = 0;
  Chart.defaults.global.scaleFontFamily = "proxima-nova";

  var adminRoot = document.getElementById('new-admin'),
      teamRoot = document.getElementById('team-root'),
      projectInsightsRoot = document.getElementById('project-insights-root'),
      projectRewardsManage = document.getElementById('project-rewards-manager-root'),
      projectIndexRoot = document.getElementById('project-index-root');

  if(adminRoot){
    m.mount(adminRoot, c.admin.Contributions);
  }

  if(teamRoot){
    m.mount(teamRoot, c.pages.Team);
  }

  if(projectIndexRoot){
    m.mount(projectIndexRoot, c.contribution.ProjectsHome);
  }

  if(projectInsightsRoot){
    m.mount(projectInsightsRoot, m.component(c.project.Insights, {root: projectInsightsRoot}));
  }

  if(projectRewardsManage){
    m.route.mode = 'hash';
    m.route(projectRewardsManage, '/', {
      '/': m.component(c.project.RewardsManage, {root: projectRewardsManage}),
      '/:rewardID': m.component(c.project.RewardSurveyManage),
    });
    //m.mount(projectRewardsManage, m.component(c.project.RewardsManage, {root: projectRewardsManage}));
  }
}(window.m, window.c, window.Chart));

window.toggleMenu = function(){
  var userMenu = document.getElementById("user-menu-dropdown");
  userMenu.classList.toggle('w--open');
};

