
class SalesTeamObserver < ActiveRecord::Observer
  observe :sales_team
  def after_create(sales_team)
    mail = SalesTeamMailer.new_team(sales_team)
    mail.deliver
    SalesTeamMailer.new_team_alert_admin(sales_team).deliver
  end
  
  #let the sales team know that their application has been approved or rejected.
  def after_update(sales_team)
    if sales_team.status_changed?
      if sales_team.status==:approved
        mail = SalesTeamMailer.welcome(sales_team)
        mail.deliver
      elsif sales_team.status==:rejected
        mail = SalesTeamMailer.rejected(sales_team)
        mail.deliver
      end
    end
  end

end