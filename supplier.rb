#represents a companu that is a supplier
class Supplier < Company
  has_many :sales_team_contracts
  has_many :sales_teams,  :through=>:sales_team_contracts
  has_many :serving_us_states,:foreign_key=>"company_id"
  has_many :us_states,  :through=>:serving_us_states
  
  	validates :tax_number, :presence=>true
    after_create :generate_warehouse
  
  
  def can_sell_wholesale
    self.sell_wholesale
  end
  #called after creating company. If it is a supplier then we generate their first warehouse with an address equivalent to their company address. This is because most suppliers have the same address for their office and warehouse. Makes it easier on the person adding the company to the DB.
  def generate_warehouse
    return true if type!="Supplier"
    Warehouse.create(:company_id=>self.id,
                     :name=>self.name,
                     :managed=>false,
                     :address=>self.address,
                     :address2=>self.address2,
                     :city=>self.city,
                     :us_state=>self.state,
                     :zipcode=>self.zipcode)
  end
  
  def samples_with_owned_products
      SampleOrder.includes(:order_items=>:product).where("products.company_id=?",self.id)
	end

  def orders_with_owned_products
		#Order.all(:joins=>{:order_items=>{:product=>:company}}, :conditions=>{:companies=>{:id=>self.id}})
    Order.find_by_sql("select Orders.* from orders where spo_order_id in (select spo_order_id from order_items oi join  products p on oi.product_id=p.id left join companies c on p.company_id=c.id where c.id=#{self.id}) order by orders.created_at DESC")
	end

  
end
