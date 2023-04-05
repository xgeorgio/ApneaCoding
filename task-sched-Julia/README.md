Title:<br/>
<b>Optimal Task Scheduler in Julia</b>

Description:<br/>
<p>This is a simple example demonstrating the basic syntax and features of Julia, with a classic problem from the Operational Research. Specifically, it creates the smallest-total-time schedule for N uninterrupted (no pauses) task 'programs' for a specific set of shared resource items. For example, if the host platform is a task scheduler of an operating system, then the requirement is to produce the best batch-type scheduling of the running tasks using the shared resources of the system. The script implements the 'naive' approach of exhaustive (combinatorial) search for finding the global optimum, thus it has inherent complexity of O( N!.R.E[T] ), where N=#tasks, R=#resources and E{T} is the mean value of the path in time slots, i.e.: 
min{Tj} <= E[Tj] <= sum{Tj} , j=1..N
