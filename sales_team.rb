#represents a company that is a sales team
class SalesTeam < Company
  has_many :sales_team_contracts
  has_many :suppliers,  :through=>:sales_team_contracts
  
  has_many :product_permissions, :dependent=>:destroy
  has_many :products,  :through=>:product_permissions

  
  has_one :sales_team_option, :foreign_key=>"company_id"
	has_many :users, :foreign_key=>"company_id"
  has_many :sample_orders, :class_name=>"SpoOrder",:foreign_key=>"company_id"
  

  
  HUMANIZED_ATTRIBUTES = {
  "sales_team_option.bio" => "Resume"
  }
  
  def self.human_attribute_name(attr, options={})
    puts "attirbution is #{attr.class}"
    HUMANIZED_ATTRIBUTES[attr.to_s] || super
  end

  #return list of suppliers that are using the sales team
  def client_list
    self.sales_team_contracts
  end
#all products that this sales team can sell for a specifc supplier
  def products_from_supplier(supplier_id)
    us_state=self.sales_team_option.state_serving
    self.products.active(true).joins(:supplier=>:us_states).where("companies.id=? and us_states.code=?",supplier_id,us_state)
  end

#all products that this sales team can sell
  def all_products
    us_state=self.sales_team_option.state_serving
    self.products.active(true).joins(:supplier=>:us_states).where("us_states.code=?",us_state)
  end

#returns sales_teams that serve a specific state
  def self.serving_in(state_code)
    self.joins(:sales_team_option).where("sales_team_options.state_serving=?",state_code)
  end
#return all sales_teams that are public
  def self.is_public
    SalesTeam.joins(:sales_team_option).where("sales_team_options.public_list=?",true)
  end

#this is called instead of update_attributes because update attributes was deleting all other product_permissions belonging to other suppliers
  def update_product_permissions(product_ids,supplier_id)
    param_ids=product_ids.clone #don't want to modify the variable that holds parameter information
    self.product_permissions.each do |product_permission|
      puts "supplier_id=#{supplier_id}"
      puts "supplier_id=#{product_permission.product.company_id} of product #{product_permission.product_id}"
      puts "#{product_permission.product.company_id.to_i!=supplier_id.to_i}"
      next if product_permission.product.company_id.to_i!=supplier_id.to_i
      index_in_param=param_ids.index(product_permission.product_id)
      puts "index for product_id #{product_permission.product_id} is #{index_in_param}"
      if index_in_param.nil?
        product_permission.destroy #delete because not found in params
      else
        param_ids.delete_at(index_in_param) #delete from param list because we will not need to add permsission since its already a permission
      end
    end
    
    param_ids.each do |product_id|
      ProductPermission.create(:product_id=>product_id,
                               :sales_team_id=>self.id
                               )
    end
  end


  def can_sell_wholesale
    self.sell_wholesale
  end
end
