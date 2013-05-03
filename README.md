Ruby on Rails Example of Associations
In this example we have the following Models
Supplier - Think of a supplier as a winery. They will be selling their products to retailers so they need a sales team.
SalesTeam - A sales team belongs to a supplier, and has many sales team members (users). A sales team also has a list of products that they can sell
SalesTeamContracts- A sales team contract is created when a sales team is hired by the supplier(winery). They have properties such as the winery and sales team that the contract is between. and commission rate to the sales team.
UsStates - represents a U.S. state. A supplier  (winery) can do business in 1 state, or many states. 
Company
You will notice that the SalesTeam model & Supplier model are both subclasses of Company. It is pretty obvious that a supplier is a company and has the same attributes that any company would have i.e. Tax ID, Address, Phone number...
It might not make sense why a Sales Team is a company at first, it requires knowledge of the specific industry to understand why. In many cases a winery will hire a 3rd party sales company, also called Brokers, to sell their products. They may employ multiple sales teams to cover multiple markets

Here is a summary of associations that are made
Supplier (winery)
has many Sales team contracts - they hire multiple sales teams to cover multiple territories
has many UsStates - to keep track of the states where the winery is doing business.


SalesTeam
has many suppliers - a sales team can be hired by many different wineries
has many products - a sales team represents many different products


SalesTeamContracts
is the glue that binds the sales team and the supplier so to represent this we state the following
belongs to sales team
belongs to supplier
