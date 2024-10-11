/*In UVM, timeouts, $finish, and drain time are all mechanisms that control the simulation’s termination and handling of processes,
but they serve different purposes and are used in different contexts. 

1) Timeout : Timeout in UVM is used to ensure that the entire simulation does not run indefinitely. 
Timeout is commonly used in UVM testbenches to detect hangs, deadlocks, or very long-running tasks that fail to complete within a reasonable time.

2) $finish : $finish is a SystemVerilog built-in system task that is used to explicitly terminate the simulation at any point in the code. 
It can be invoked anywhere in the simulation to stop it. $finish is used when you want to manually stop the simulation, such as after a test has completed or a specific condition has been met in a non-UVM testbench.

3) Drain time : Drain time in UVM refers to a grace period given to the simulation after all objections have been dropped and the UVM phases have completed. 
This allows any ongoing transactions or processes to finish naturally before the simulation stops.
Drain time is useful when you want to allow ongoing transactions or tasks to finish after the last objection has been dropped in a phase.
It provides a buffer time to avoid abruptly stopping ongoing processes, which might still need to complete.

Summary : Timeout: Prevents the simulation from running indefinitely by stopping it if it exceeds a certain time, 
$finish is use to manually stop simulation as and when required, 
Drain time is use to wait for some time after the last objection is dropped in UVM phases to cleanly processed last stimulus.*/
