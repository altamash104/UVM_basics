/*Q.What is the diference between uvm_config_db and uvm_resource_db?

Ans-Both the uvm_config_db and the uvm_resource_db provide a convenience interface for the resource database. UVM recommends using the uvm_config_db as it is more robust.

uvm_config_db is more robust because with uvm_config_db, we can restrict the db so that it will not be visible to certain components. In other words, while setting up the config_db, we can set a path. So, that this db can be accessed only by the components that are existing in the specified path… But, uvm_resource_db has no such facility (since this db can be accessed by any of the components inTB) uvm_resource_db has global visibility.


Q.How is uvm_config_db diffrent from set_inst_override or set_type_override, In which context should we use each of them. 

Ans-

The uvm_config_db is used to share information between components and objects. 
For example, the top-level test-bench module often stores a virtual interface to the uvm_config_db. Then a uvm_driver can get the interface from the database .

The set_inst_override and set_type_override are used to substitute a component or an object for another without changing the test-bench code. For example, a user can substitute a transaction for an error transaction. Please see this for how we substituted a jelly bean with a sugar-free jelly bean from a test.

*/
