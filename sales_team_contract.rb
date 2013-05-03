class SalesTeamContract < ActiveRecord::Base
      attr_accessor :user_mod
  belongs_to :supplier
  belongs_to :sales_team
  
  validates :commission, :presence=>true,:numericality=>{:greater_than_or_equal_to => 0,:less_than=>100}
  validates :sales_team_id, :presence=>true,:numericality=>true
  validates :supplier_id, :presence=>true,:numericality=>true
  
  before_destroy :check_user
  after_destroy :alert_all_fire, :delete_product_permission
  after_create :alert_sales_team_hire, :add_product_permission

  #make sure that we have set the user_mod field so we know who is cancelling the commission agreement.
  #only check when before destory because this affects the email that gets sent out.
  def check_user
    if User.find_by_id(user_mod).nil?
      errors.add_to_base "Must specify the user that is cancelling the agreement."
      return false 
    end
  end
  #send alert to sales team and supplier when someone is fired.
  def alert_all_fire
    begin
      SalesTeamMailer.canceled_agreement_alert_team(self).deliver
      SalesTeamMailer.canceled_agreement_alert_supplier(self).deliver
    rescue Exception => exc
      puts "ERROR #{exc.message}"
    end
  end
  #send email to sales team when they are hired
  def alert_sales_team_hire
    begin
      mail = SalesTeamMailer.hired_sales_team(self)
      mail.deliver
      rescue Exception => exc
      puts "ERROR #{exc.message}"
    end
  end
  #all product permissions given by supplier to sales_team must be deleted
  def delete_product_permission
    ProductPermission.destroy_agreement(sales_team_id,supplier_id)
  end
  
  #by default when new sales_team is added give it permission of all of the supplier's products
  def add_product_permission
    ProductPermission.add_all_products(sales_team_id,supplier_id)

  end
end
